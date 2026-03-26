import { AppRouter } from "routers/app_router";

$(document).ready(function () {
  var router = new AppRouter();
  Backbone.history.start({ pushState: true });
});