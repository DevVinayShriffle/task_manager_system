import { LoginView } from "views/login_view";
import { SignupView } from "views/signup_view";
import { DashboardView } from "views/dashboard_view";

export var AppRouter = Backbone.Router.extend({
  routes: {
    "": "login",
    "login": "login",
    "signup": "signup",
    "dashboard":"dashboard"
  },

  login: function () {
    var view = new LoginView();
    view.render();
  },

  signup: function () {
    var view = new SignupView();
    view.render();
  },

  dashboard: function () {
    var view = new DashboardView();
    view.render();
  }
});