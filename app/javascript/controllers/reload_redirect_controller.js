import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Check if the isReload flag is set in session storage
    if (sessionStorage.getItem('isReload')) {
      sessionStorage.removeItem('isReload'); // Clear the flag
      
      // Get the path from data-attribute
      const redirectPath = this.element.dataset.redirectPath;
      
      if (redirectPath) {
        // Perform the redirect
        if (typeof Turbo !== 'undefined') {
          Turbo.visit(redirectPath);
        } else {
          window.location.href = redirectPath;
        }
      }
    }

    // Add event listener to set the flag just before the page reloads
    this.boundSetReloadFlag = this.setReloadFlag.bind(this);
    window.addEventListener('beforeunload', this.boundSetReloadFlag);
  }

  disconnect() {
    // Clean up
    window.removeEventListener('beforeunload', this.boundSetReloadFlag);
  }

  setReloadFlag() {
    // Set the flag in session storage when a reload is imminent
    sessionStorage.setItem('isReload', 'true');
  }
}
