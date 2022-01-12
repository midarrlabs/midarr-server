import topbar from "../vendor/topbar"
// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket, Presence} from "phoenix"

// And connect to the path in "lib/media_server_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/media_server_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/media_server_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/media_server_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
let channel = socket.channel("room:lobby", { user_id: window.userId, current_location: window.location.href })
let presence = new Presence(channel)

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#6366f1"}, shadowColor: "rgba(0, 0, 0, .3)"})

window.addEventListener("phx:page-loading-start", info => topbar.show())

window.addEventListener("phx:page-loading-stop", info => {

    if (info.detail.kind === 'initial') {
        channel.push('shout', { user_id: window.userId, current_location: window.location.href })
    }

    topbar.hide()
})

channel.on("shout", message => {
  console.log(message)
})

function renderOnlineUsers(presence) {

  let response = 0

  presence.list((id, metas) => {
    if (id !== window.userId) {
        response = response + 1
    }
  })

  const element = document.querySelector("#users-online")

  if (element) {

    if (response) {
        element.innerHTML = response
        element.style.display = 'block'
    } else {
        element.style.display = 'none'
    }
  }
}

presence.onSync(() => renderOnlineUsers(presence))

channel.join()
  .receive("ok", resp => {

    console.log("Joined successfully", resp)
  })
  .receive("error", resp => { 

    console.log("Unable to join", resp) 
  })

export default socket
