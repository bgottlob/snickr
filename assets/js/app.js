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

// TODO This is a really fast and dirty way to only establish the societ when on
// the channel show view. Break this out into a separate file then require it
// in the channel show view specifically
if (document.querySelector('#channel-data')) {
  let channelId = Number(document.querySelector('#channel-data').getAttribute('data-id'))
  let userId = Number(document.querySelector('#user-data').getAttribute('data-id'))
  let channel = socket.channel("room:" + channelId, {})
  let chatInput = document.querySelector('#chat-input')
  let chatForm = document.querySelector('#chat-form')
  let messagesContainer = document.querySelector("#messages")

  chatInput.addEventListener('keypress', event=> {
    if (event.keyCode == 13){
      channel.push('new_msg', {
        content: chatInput.value,
        channel_id: channelId,
        user_id: userId
      })
      chatInput.value = ''
    }
  })

  channel.on('new_msg', message => {
    renderMessage(messagesContainer, message)
  })

  // Escapes untrusted strings
  function esc(str) {
    let div = document.createElement('div')
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  }

  function renderMessage(container, message) {
    let template = document.createElement('div')
    template.innerHTML = `
  <li style="list-style: none"><em style="font-size: 0.7em">${esc(new Date(message.inserted_at).toLocaleString())}</em><br><strong>${esc(message.sent_by_user.username)}:</strong> ${esc(message.content)}</li>
  `
    container.appendChild(template)
    container.scrollTop = container.scrollHeight
  }

  channel.join()
    .receive('ok', ({messages}) => {
      console.log(messages)
      messages.forEach(m => renderMessage(messagesContainer, m))
    })
}
export default socket
