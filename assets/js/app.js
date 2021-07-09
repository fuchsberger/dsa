// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//

import Alpine from 'alpinejs'
import 'phoenix_html'
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"
import algoliasearch from 'algoliasearch/lite'
// import SimpleScrollbar from 'simple-scrollbar'
import topbar from "topbar"

// Start Alpine.js
Alpine.start()

// Configure Live Sockets
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        Alpine.clone(from.__x, to);
      }
    }
  },
  params: {_csrf_token: csrfToken},
  metadata: { keydown: e => ({key: e.key, metaKey: e.metaKey, repeat: e.repeat}) }
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// Connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// window.SimpleScrollbar = SimpleScrollbar
/**
 * Configure Algoria search
 *
 * Every search entry should have the following properties:
 * objectID (unique in format type_id if persistent database record)
 * type
 * name
 * path
 * description (optional)
 * list_name (optional)
 * list_entries (optional)
 */
let env = document.querySelector("meta[name='environment']").getAttribute("content")
const client = algoliasearch('WL8XME362C', '6c57ebae586cc1d9895ec316af1491d8')
global.searchIndex = client.initIndex(env + '_records')
