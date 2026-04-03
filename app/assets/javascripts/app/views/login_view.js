var LoginView = Marionette.View.extend({
  template: "#login-template",

  events: {
    "submit #login-form": "loginUser"
  },

  loginUser: function (e) {
    e.preventDefault();

    var email = this.$("#email").val();
    var password = this.$("#password").val();

    API.request({
      url: "/users/login",
      method: "POST",
      data: { user: { email: email, password: password } },
      success: function (res) {
        localStorage.setItem("token", res.meta.token);
        Backbone.history.navigate("tasks", { trigger: true });
      },
      error: function () {
        alert("Invalid credentials");
      }
    });
  }
});