import * as Turbo from "@hotwired/turbo"
import "../css/app.css"
import "phoenix_html"
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

document.addEventListener("turbo:load", function() {

  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
  const liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    metadata: { keydown: e => ({key: e.key, metaKey: e.metaKey, repeat: e.repeat}) }
  })

  // Connect if there are any LiveViews on the page
  liveSocket.connect()

  // Enable mobile button
  const mobile_button = document.getElementById("mobile-button")

  mobile_button.addEventListener('click', () => {

    for(let svg of mobile_button.getElementsByTagName("svg")){
      svg.classList.toggle("block")
      svg.classList.toggle("hidden")
    }

    let menu = document.getElementById("mobile-menu")
    menu.classList.toggle("hidden")
    menu.classList.toggle("block")
  })

  // Enable log button
  const log_button = document.getElementById("log-button")

  if(log_button){
    log_button.addEventListener('click', () => {
      log_button.classList.toggle("active")

      for(let elm of document.getElementById("main-wrapper").children){
        elm.classList.toggle("block")
        elm.classList.toggle("hidden")
      }
    })
  }

  // Enable notification dismissal
  (document.querySelectorAll('button.dismiss') || []).forEach(elm =>
    elm.addEventListener('click', () => elm.parentNode.parentNode.removeChild(elm.parentNode))
  )
})
