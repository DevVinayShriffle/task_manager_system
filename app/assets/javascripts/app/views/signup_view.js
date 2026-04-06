window.SignupView = Marionette.View.extend({
  template: JST["app/templates/signup"],

  events: {
    "submit #signupForm": "signup"
  },

  signup: function (e) {
    e.preventDefault();

    var email = this.$("#email").val();
    var password = this.$("#password").val();
    var self = this;

    $.ajax({
      url: "/users",
      method: "POST",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify({
        user: { email: email, password: password }
      }),

      success: function (res) {
        if (res.meta && res.meta.token) {
          localStorage.setItem("token", res.meta.token);
        }
        alert(res.meta.message || "Signed up successfully");
        window.router.navigate("tasks", { trigger: true }); // redirect to tasks
      },

      error: function (xhr) {
        var msg = xhr.responseJSON?.message || "Failed to sign up";
        self.$("#error").text(msg);
      }
    });
  }
});