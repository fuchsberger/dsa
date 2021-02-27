import "../css/app.css"
import "phoenix_html"
import * as Turbo from "@hotwired/turbo"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  metadata: { keydown: e => ({key: e.key, metaKey: e.metaKey, repeat: e.repeat}) }
})

// Connect if there are any LiveViews on the page
liveSocket.connect()


document.addEventListener("turbo:load", function() {

  // Select mobile button
  let mobile_button = document.getElementById("mobile-button")

  // Add a click event on it
  mobile_button.addEventListener('click', e => {

    // Toggle the classes in the mobile menu button
    for(let svg of mobile_button.getElementsByTagName("svg")){
      svg.classList.toggle("block")
      svg.classList.toggle("hidden")
    }

    let menu = document.getElementById("mobile-menu")
    menu.classList.toggle("hidden")
    menu.classList.toggle("block")
  })

  // Enable Log Button
  let el = document.getElementById("log-button")

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
  (document.querySelectorAll('button.dismiss') || []).forEach(elm =>
    elm.addEventListener('click', () => elm.parentNode.parentNode.removeChild(elm.parentNode))
  )
})
