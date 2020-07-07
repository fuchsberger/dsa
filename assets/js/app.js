import "../css/app.scss"
import "phoenix_html"

import "autoprefixer"
import "popper.js"
import Dropdown from 'bootstrap/js/dist/dropdown.js'
import Alert from 'bootstrap/js/dist/alert.js'

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

const hooks = {}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks, params: {_csrf_token: csrfToken}})

// Connect if there are any LiveViews on the page
liveSocket.connect()
