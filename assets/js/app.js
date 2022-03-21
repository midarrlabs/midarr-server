import "phoenix_html"
import { Socket, Presence } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let socket = new Socket("/socket", {})
socket.connect()

let channel = socket.channel("room:lobby", { user_id: window.userId, user_name: window.userName })
let presence = new Presence(channel)

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

topbar.config({barColors: {0: "#dc2626"}, shadowColor: "rgba(0, 0, 0, .3)"})

window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

let game = new Phaser.Game({
    parent: 'game',
    type: Phaser.AUTO,
    width: '100%',
    height: '100%',
    physics: {
       default: 'arcade',
       arcade: {
           debug: true,
       }
    }
})

class MyScene extends Phaser.Scene {

    player = {}
    otherPlayers = {}
    cursors = {}

    preload() {
        this.load.image('red', 'http://labs.phaser.io/assets/sprites/red_ball.png')

        presence.onSync(() => {
            for (const property in presence.state) {
              if (parseInt(property) !== window.userId) {
                this.otherPlayers[property] = this.physics.add.image(400, 300, 'red')
              }
            }
        })

        channel.on("player_position", ({ user_id, x, y }) => {
            if (user_id !== window.userId) {
                this.otherPlayers[user_id].setX(x)
                this.otherPlayers[user_id].setY(y)
            }
        })

        channel.on("player_left", ({ user_id }) => {
            if (user_id !== window.userId) {
                this.otherPlayers[user_id].destroy()
            }
        })
    }

    create(data) {
        this.player = this.physics.add.image(data.x, data.y, 'red')

        this.player.setCollideWorldBounds(true)

        this.cursors = this.input.keyboard.createCursorKeys()
    }

    update() {
        this.player.setVelocity(0)

        if (this.cursors.left.isDown) {
            this.player.setVelocityX(-300)

            channel.push('player_position', { user_id: window.userId, x: this.player.x, y: this.player.y, })
        }
        else if (this.cursors.right.isDown) {
            this.player.setVelocityX(300)

            channel.push('player_position', { user_id: window.userId, x: this.player.x, y: this.player.y, })
        }

        if (this.cursors.up.isDown) {
            this.player.setVelocityY(-300)

            channel.push('player_position', { user_id: window.userId, x: this.player.x, y: this.player.y, })
        }
        else if (this.cursors.down.isDown) {
            this.player.setVelocityY(300)

            channel.push('player_position', { user_id: window.userId, x: this.player.x, y: this.player.y, })
        }
    }
}

game.scene.add('myScene', MyScene, true, { x: 400, y: 300 })

window.addEventListener('beforeunload', function (e) {
    channel.push('player_left', { user_id: window.userId })
    // the absence of a returnValue property on the event will guarantee the browser unload happens
    delete e['returnValue']
});

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
