import { LoginView } from "views/login_view";

export var SignupView = Backbone.View.extend({
  el: "#app",

  template: _.template($("#signup-template").html()),

  events: {
    "click #signup-btn": "signupUser",
    "click #go-login": "goLogin"
  },

  render: function () {
    this.$el.html(this.template());
  },

  signupUser: function () {
    var email = this.$("#email").val();
    var password = this.$("#password").val();

    $.ajax({
      url: "/users",
      method: "POST",
      data: {
        user: {
          email: email,
          password: password
        }
      },
      success: function (res, status, xhr) {
        console.log("Signup success");

        var token = xhr.getResponseHeader("Authorization");
        localStorage.setItem("token", token);

        Backbone.history.navigate("dashboard", {trigger: true});
      },
      error: function (err) {
        console.log("Signup failed");
      }
    });
  },

  goLogin: function (e) {
    e.preventDefault();
    Backbone.history.navigate("login", { trigger: true });
  }
});