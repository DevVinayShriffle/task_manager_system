import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "error"]

  validate(event) {
    if (this.titleTarget.value.trim() === "") {
      event.preventDefault()
      this.errorTarget.textContent = "Title can't be blank"
      this.titleTarget.classList.add("input-error")
    } else {
      this.errorTarget.textContent = ""
      this.titleTarget.classList.remove("input-error")
    }
  }
}
