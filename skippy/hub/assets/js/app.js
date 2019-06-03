// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {params: {user_id: window.userId}})

socket.connect()

let userList = document.getElementById("user-list")
let room = socket.channel("rooms:lobby", {})
let presences = {}

let listBy = (id, {metas: [first, ...rest]}) => {
  first.name = id
  first.count = rest.length + 1
  return first
}

let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(user => `<li>${user.name} (${user.count})</li>`)
    .join("")
}

room.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  render(presences)
})

room.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  render(presences)
})

room.join()