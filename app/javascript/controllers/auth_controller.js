import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["email", "password", "emailError", "passwordError"]

  validate(event) {
    let valid = true

    const email = this.emailTarget.value.trim()
    const password = this.passwordTarget.value.trim()

    const passwordRegex =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[^\s]{6,8}$/

    // Email validation
    if (email === "") {
      this.emailErrorTarget.textContent = "Email is required"
      valid = false
    } else {
      this.emailErrorTarget.textContent = ""
    }

    // Password validation
    if (password === "") {
      this.passwordErrorTarget.textContent = "Password is required"
      valid = false
    } else if (!passwordRegex.test(password)) {
      this.passwordErrorTarget.textContent = "Password format is invalid"
      valid = false
    } else {
      this.passwordErrorTarget.textContent = ""
    }

    if (!valid) {
      event.preventDefault()
    }
  }
}
