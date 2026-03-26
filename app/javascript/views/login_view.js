import { SignupView } from "views/signup_view";

export var LoginView = Backbone.View.extend({
  el: "#app",

  template: _.template($("#login-template").html()),

  events: {
    "click #login-btn": "loginUser",
    "click #go-register": "goRegister"
  },

  render: function () {
    this.$el.html(this.template());
  },

  loginUser: function () {
    console.log("Login button clicked");
    var email = this.$("#email").val();
    var password = this.$("#password").val();

    $.ajax({
      url: "/users/login",
      method: "POST",
      data: {
        user: {
          email: email,
          password: password
        }
      },
      success: function (res, status, xhr) {
        console.log("Login success");
        var token = xhr.getResponseHeader("Authorization");
        localStorage.setItem("token", token);
      },
      error: function () {
        console.log("Login failed");
      }
    });
  },

  goRegister: function (e) {
    e.preventDefault();
    Backbone.history.navigate("signup", { trigger: true });
  },
});