import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  toggle(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.toggle("show")
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.remove("show")
    }
  }

  connect() {
    document.addEventListener("click", this.close.bind(this))
  }
}
