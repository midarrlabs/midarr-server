import "phoenix_html"
import { Socket, Presence } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let socket = new Socket("/socket", {})
socket.connect()

let channel = socket.channel("room:lobby", { user_id: window.userId, user_name: window.userName, page_title: document.title, current_location: window.location.href })
let presence = new Presence(channel)

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

topbar.config({barColors: {0: "#dc2626"}, shadowColor: "rgba(0, 0, 0, .3)"})

window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

presence.onSync(() => {
    let presences = []

    presence.list((id, {metas: [first, ...rest]}) => {
        presences.push(first)
    })

    const element = document.querySelector("#users")

    if(element) {
        for (const item of presences) {

            const user = document.querySelector(`#user-id-${item.user_id}`)

            user.innerHTML = ""
            user.innerHTML += '<span class="bg-green-400 absolute top-0 right-0 block h-2.5 w-2.5 rounded-full ring-2 ring-white" aria-hidden="true"></span>'
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
    params: { _csrf_token: csrfToken },
    hooks: {
        video: {
            mounted() {
                window.addEventListener("beforeunload", event => {
                    this.pushEvent("video_destroyed", {
                        current_time: Math.floor(this.el.currentTime),
                        duration: Math.floor(this.el.duration)
                    })

                    delete event["returnValue"]
                })

                this.pushEvent("video_played")
            },
            destroyed() {
                window.removeEventListener("beforeunload")
            }
        }
    }
})

liveSocket.connect()
//liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
