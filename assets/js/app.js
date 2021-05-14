import "../css/app.css"
import 'alpinejs'

import "phoenix_html"
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

document.addEventListener("turbo:load", function() {

  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
  const liveSocket = new LiveSocket("/live", Socket, {
    dom: {
      onBeforeElUpdated(from, to) {
        if (from.__x) {
          window.Alpine.clone(from.__x, to);
        }
      }
    },
    params: {_csrf_token: csrfToken},
    metadata: { keydown: e => ({key: e.key, metaKey: e.metaKey, repeat: e.repeat}) }
  })

  // Connect if there are any LiveViews on the page
  liveSocket.connect()

  // Enable notification dismissal
  (document.querySelectorAll('button.dismiss') || []).forEach(elm =>
    elm.addEventListener('click', () => elm.parentNode.parentNode.removeChild(elm.parentNode))
  )
})
