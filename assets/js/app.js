import "../css/app.scss"
import "phoenix_html"

import "popper.js"
import Dropdown from 'bootstrap/js/dist/dropdown.js'
import Alert from 'bootstrap/js/dist/alert.js'
import Tab from 'bootstrap/js/dist/tab.js'
import Tooltip from 'bootstrap/js/dist/tooltip.js'

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let tooltipTriggerList, tooltipList = []

const enableTooltips = () => {
  tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new Tooltip(tooltipTriggerEl)
  })
}

const hooks = {}

hooks.tooltip = {
  mounted() {
    enableTooltips()
  },

  updated() {
    enableTooltips()
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks, params: {_csrf_token: csrfToken}})

// Connect if there are any LiveViews on the page
liveSocket.connect()

// enable tooltips
enableTooltips()
