console.log("Appjs")

var App = new Marionette.Application({
  region: "#app"
});

App.on("start", function () {
  console.log("App mounted on #app");

  if (Backbone.history) {
    Backbone.history.start();
  }
});

// Start app AFTER everything is loaded
$(document).ready(function () {
  console.log("DOM loaded");
  App.start();
});