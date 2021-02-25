import "../css/app.css"
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  metadata: { keydown: e => ({key: e.key, metaKey: e.metaKey, repeat: e.repeat}) }
})

// Connect if there are any LiveViews on the page
liveSocket.connect()

let el

// Enable Mobile Button
el = document.getElementById("mobile-button")

if (el !== null) {

  // Add a click event on it
  el.addEventListener('click', () => {

    // Toggle the classes in the mobile menu button
    for(let svg of el.getElementsByTagName("svg")){
      svg.classList.toggle("block")
      svg.classList.toggle("hidden")
    }

    let menu = document.getElementById("mobile-menu")
    menu.classList.toggle("hidden")
    menu.classList.toggle("block")
  })
}

// Enable Log Button
el = document.getElementById("log-button")

if (el !== null) {

  // Add a click event on it
  el.addEventListener('click', () => {

    // Toggle the classes in the mobile menu button
    el.classList.toggle("active")

    for(let elm of el.children){
      elm.classList.toggle("block")
      elm.classList.toggle("hidden")
    }
  })
}

// Enable Notification dismissal
(document.querySelectorAll('.notification .delete') || []).forEach(elm =>
  elm.addEventListener('click', () => elm.parentNode.parentNode.removeChild(elm.parentNode))
);
