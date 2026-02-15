import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "error"]

  validate(event) {
    const value = this.passwordTarget.value.trim()

    const passwordRegex =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[^\s]{6,8}$/

    if (value === "") {
      event.preventDefault()
      this.errorTarget.textContent = "Password is required"
      this.passwordTarget.classList.add("input-error")
    } else if (!passwordRegex.test(value)) {
      event.preventDefault()
      this.errorTarget.textContent = "Password format is invalid"
      this.passwordTarget.classList.add("input-error")
    } else {
      this.errorTarget.textContent = ""
      this.passwordTarget.classList.remove("input-error")
    }
  }
}
