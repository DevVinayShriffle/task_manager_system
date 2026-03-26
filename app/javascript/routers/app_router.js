import { LoginView } from "views/login_view";
import { SignupView } from "views/signup_view";

export var AppRouter = Backbone.Router.extend({
  routes: {
    "": "login",
    "login": "login",
    "signup": "signup"
  },

  login: function () {
    var view = new LoginView();
    view.render();
  },

  signup: function () {
    var view = new SignupView();
    view.render();
  }
});