import Backbone from "backbone";
import { LoginView } from "./views/login_view";
import { DashboardView } from "./views/dashboard_view";
import { App } from "./app";

export const AppRouter = Backbone.Router.extend({
  routes: {
    "": "login",
    "login": "login",
    "dashboard": "dashboard"
  },

  login() {
    App.showView(new LoginView());
  },

  dashboard() {
    App.showView(new DashboardView());
  }
});
