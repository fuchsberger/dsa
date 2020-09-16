import "../css/app.scss"
import "phoenix_html"

import "popper.js"
import { Alert, Dropdown, Tab, Tooltip, Popover } from 'bootstrap';

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let tooltipTriggerList, tooltipList = []
let popoverTriggerList, popoverList = []

const enableTooltips = () => {
  tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  tooltipList = tooltipTriggerList.map(el => new Tooltip(el))

  // also enable popovers
  popoverTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="popover"]'))
  popoverList = popoverTriggerList.map(el => new Popover(el))
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
