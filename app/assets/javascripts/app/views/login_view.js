window.LoginView = Marionette.View.extend({
  template: JST["app/templates/login"],

  events: {
    "submit #loginForm": "login"
  },

  login: function (e) {
    e.preventDefault();

    var email = this.$("#email").val();
    var password = this.$("#password").val();

    $.ajax({
      url: "/users/login",
      method: "POST",
      contentType: "application/json",
      dataType: 'json',
      data: JSON.stringify({
      	user: {
	      email: email,
	      password: password
	    }
      }),

      success: function (res) {
        console.log("Login success");

        if (res.meta && res.meta.token) {
		    localStorage.setItem("token", res.meta.token);
		}

		  // Navigate via router instead of directly showing view
		  router.tasksCollection = new TaskCollection();
		  router.tasksCollection.fetch({
		    success: function() {
		      router.navigate("users/tasks", { trigger: true });
		    }
		  });
      },

      error: function () {
        $("#error").text("Invalid email or password");
      }
    });
  }
});