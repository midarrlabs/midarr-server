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

window.addEventListener('beforeunload', event => {
    channel.push('player_left', { user_id: window.userId })

    delete event['returnValue']
})

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
        this.load.image('box', 'https://labs.phaser.io/assets/sprites/box-item-boxed.png')
        this.load.image('red', 'https://labs.phaser.io/assets/sprites/red_ball.png')

        presence.onSync(() => {
            for (const property in presence.state) {
              if (parseInt(property) !== window.userId) {
                this.otherPlayers[property] = this.physics.add.image(400, 600, 'red')
              }
            }
        })

        channel.on("player_position", ({ user_id, x, y }) => {
            if (user_id !== window.userId) {
                this.otherPlayers[user_id].setPosition(x, y)
            }
        })

        channel.on("player_left", ({ user_id }) => {
            if (user_id !== window.userId) {
                this.otherPlayers[user_id].destroy()
            }
        })
    }

    create(data) {
        const movies = this.physics.add.image(50, 50, 'box').setOrigin(0, 0)
        this.add.text(55, 130, 'Movies')

        const series = this.physics.add.image(350, 50, 'box').setOrigin(0, 0)
        this.add.text(355, 130, 'Series')

        const continues = this.physics.add.image(650, 50, 'box').setOrigin(0, 0)
        this.add.text(600, 130, 'Continue Watching')

        this.player = this.physics.add.image(data.x, data.y, 'red').setCollideWorldBounds(true)
        this.add.text(250, 550, 'Use keyboard arrows to control')

        this.cursors = this.input.keyboard.createCursorKeys()

        this.physics.add.overlap(this.player, movies, (player, movies) => {
            console.log('movies')
            player.disableBody()
        })

        this.physics.add.overlap(this.player, series, (player, series) => {
            console.log('series')
            player.disableBody()
        })

        this.physics.add.overlap(this.player, continues, (player, continues) => {
            console.log('continue watching')
            player.disableBody()
        })
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

game.scene.add('myScene', MyScene, true, { x: 400, y: 600 })

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
