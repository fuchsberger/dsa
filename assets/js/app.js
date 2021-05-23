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

import Spruce from '@ryangjchandler/spruce'
import 'alpinejs'
import algoliasearch from 'algoliasearch/lite'
import 'phoenix_html'
import {Socket} from "phoenix"
import topbar from "topbar"
import LiveSocket from "phoenix_live_view"
// import "phoenix_html"

// Configure Live Sockets
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
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

// Configure Algoria search
const client = algoliasearch('WL8XME362C', '6c57ebae586cc1d9895ec316af1491d8')
const index = client.initIndex('records')

// TODO: delete
Spruce.store('search', {
  modal: false,
  query: "",
  results: [{title: "Test", path: "/", desc: "Desc"}],
  openModal() { this.modal = true },
  closeModal() { this.modal = false },
  modalIsOpen() { return this.modal === true }
})

Spruce.watch('search.query', query => {
  if(query.length < 3){
    Spruce.reset('search', { query, results: [] })
    return
  }

  index.search(query).then(results => {
    Spruce.reset('search', { query, results: results.hits })
  });
})

Spruce.starting(function(){
  alert("TEST")

  // x-on:keydown.escape="alert('Esc key  pressed.')"
})
