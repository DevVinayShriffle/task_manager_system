// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.debounceTimer = null;
  }

  submit() {
    clearTimeout(this.debounceTimer);
    // Debounce for 300ms
    this.debounceTimer = setTimeout(() => {
      this.element.requestSubmit();
    }, 300);
  }
}
