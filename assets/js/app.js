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
    console.log(presence)
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
        movie: {
            mounted() {
                const urlParams = new URLSearchParams(window.location.search)

                if (urlParams.has("seconds")) {
                    this.el.currentTime = urlParams.get("seconds")
                }

                window.addEventListener("beforeunload", event => {
                    this.pushEvent("movie_destroyed", {
                        movie_id: window.movie_id,
                        current_time: Math.floor(this.el.currentTime),
                        duration: Math.floor(this.el.duration),
                        user_id: window.userId
                    })

                    delete event["returnValue"]
                })
            },
            destroyed() {
                window.removeEventListener("beforeunload")
            }
        },
        episode: {
            mounted() {
                const urlParams = new URLSearchParams(window.location.search)

                if (urlParams.has("seconds")) {
                    this.el.currentTime = urlParams.get("seconds")
                }

                window.addEventListener("beforeunload", event => {
                    this.pushEvent("episode_destroyed", {
                        episode_id: window.episode_id,
                        serie_id: window.serie_id,
                        current_time: Math.floor(this.el.currentTime),
                        duration: Math.floor(this.el.duration),
                        user_id: window.userId
                    })

                    delete event["returnValue"]
                })
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