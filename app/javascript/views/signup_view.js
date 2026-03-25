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
        alert("Signup success");

        var token = xhr.getResponseHeader("Authorization");
        localStorage.setItem("token", token);
      },
      error: function (err) {
        alert("Signup failed");
      }
    });
  },

  goLogin: function () {
    var loginView = new LoginView();
    loginView.render();
  }
});