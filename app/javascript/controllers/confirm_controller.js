import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect(){
    console.log("Controller connected!")
  }
  confirm(event) {
    if (!confirm("Are you sure?")) {
      event.preventDefault()
      event.stopImmediatePropagation()
    }
  }
}
