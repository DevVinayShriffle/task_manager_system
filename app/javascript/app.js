import Marionette from "backbone.marionette";
import { AppRouter } from "./router";

export const App = new Marionette.Application({
  region: "#app"
});

App.on("start", function () {
  new AppRouter();
  Backbone.history.start();
});
