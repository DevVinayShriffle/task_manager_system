// Create global App
window.App = new Marionette.Application({
  region: "#app"
});

// Optional helper to show views
App.showView = function(view) {
  this.getRegion().show(view);
};

App.on("start", function () {
  console.log("App started");
});

// Start app when DOM is ready
$(document).ready(function () {
  console.log("DOM loaded");
  App.start();
});