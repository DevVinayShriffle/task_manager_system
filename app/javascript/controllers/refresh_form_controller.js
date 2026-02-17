import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="refresh-form"
export default class extends Controller {
  refresh(){
    // Find the turbo-frame element
    const frame = document.querySelector("turbo-frame#tasks");
    
    if(frame){
      frame.reload();
      console.log("Tasks reloaded");
    } else {
      console.log("Refresh form error: #tasks frame not found");
    }
  }
}
