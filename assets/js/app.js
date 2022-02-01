import "phoenix_html"
import { Socket, Presence } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let socket = new Socket("/socket", {})
socket.connect()

let channel = socket.channel("room:lobby", { user_id: window.userId, user_name: window.userName, page_title: document.title, current_location: window.location.href })
let presence = new Presence(channel)

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

topbar.config({barColors: {0: "#6366f1"}, shadowColor: "rgba(0, 0, 0, .3)"})

window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => {
    if (info.detail.kind === 'initial' && window.location.toString().includes("/watch")) {
        channel.push('shout', { user_id: window.userId, page_title: document.title })
    }

    topbar.hide()
})

channel.on("shout", message => {
    const element = document.querySelector(`#user-status-${ message.user_id }`)

    if(element) {
        element.innerHTML = `Watching ${ message.page_title }`
    }
})

presence.onSync(() => {
  let presences = []

  presence.list((id, {metas: [first, ...rest]}) => {
    presences.push(first)
  })

  const element = document.querySelector("#online-users")

  if(element) {
    element.innerHTML = ''

    for (const item of presences) {
      element.innerHTML += `<li id="online-user-${ item.user_id }">
                               <div class="relative group py-6 px-5 flex items-center">
                                 <div class="-m-1 flex-1 block p-1">
                                   <div class="absolute inset-0" aria-hidden="true"></div>
                                   <div class="flex-1 flex items-center min-w-0 relative">
                                     <span class="flex-shrink-0 inline-block relative">
                                     <span class="inline-block h-10 w-10 rounded-full overflow-hidden bg-gray-100">
                                       <svg class="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                                         <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                                       </svg>
                                     </span>
                                       <span class="bg-green-400 absolute top-0 right-0 block h-2.5 w-2.5 rounded-full ring-2 ring-white" aria-hidden="true"></span>
                                     </span>
                                     <div class="ml-4 truncate">
                                        <p class="text-sm text-gray-900 truncate whitespace-normal">${ item.user_name }</p>
                                        <p id="user-status-${ item.user_id }" class="text-sm text-gray-500 truncate whitespace-normal">${ item.current_location.includes("/watch") ? `Watching ${ item.page_title }` : 'Online' }</p>
                                     </div>
                                   </div>
                                 </div>
                               </div>
                         </li>`
    }
  }
})

channel.join()
  .receive("ok", resp => {

    console.log("Joined successfully", resp)
  })
  .receive("error", resp => {

    console.log("Unable to join", resp)
  })

let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken }
})

liveSocket.connect()
liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
