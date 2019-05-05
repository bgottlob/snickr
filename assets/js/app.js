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
import socket from "./socket"

let channel         = socket.channel("room:lobby", {})
let chatInput       = document.querySelector("#chat-input")
let messagesContainer= document.querySelector("#messages")


chatInput.addEventListener("keypress", event=> {
    if(event.keyCode == 13){
        channel.push("new_msg", {body: chatInput.value})
        chatInput.value = ''
    }
})

channel.on("new_msg", payload => {
    let messageItem = document.createElement("li")
    messageItem.innerText = `[${Date()}]${payload.body}`
    messagesContainer.appendChild(messageItem)
})

channel.join()
export default socket