import Marionette from "backbone.marionette";
import template from "../templates/login.hbs";
import Radio from "backbone.radio";
import Backbone from "backbone";

export const LoginView = Marionette.View.extend({
  template,

  events: {
    "submit #login-form": "handleLogin"
  },

  handleLogin(e) {
    e.preventDefault();

    const email = this.$("input[name='email']").val();
    const password = this.$("input[name='password']").val();

    const channel = Radio.channel("auth");

    channel.request("login", { email, password })
      .then((res) => {
        if (res.token) {
          localStorage.setItem("token", res.token);

          Backbone.history.navigate("dashboard", { trigger: true });
        } else {
          this.$(".error").text(res.error);
        }
      })
      .catch(() => {
        this.$(".error").text("Something went wrong");
      });
  }
});
