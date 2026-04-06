window.AppRouter = Backbone.Router.extend({
  routes: {
    "": "showLogin",
    "login": "showLogin",
    "signup": "showSignup",
    "users/tasks": "showTasksDashboard"
  },

  showLogin: function () {
    App.showView(new LoginView());
  },

  showSignup: function () {
    App.showView(new SignupView());
  },

  showTasksDashboard: function () {
    // App.showView(new TasksDashboardView());
    if (!this.tasksCollection) {
      this.tasksCollection = new TaskCollection();
      var self = this;

      this.tasksCollection.fetch({
        success: function () {
          App.showView(new TasksDashboardView({ collection: self.tasksCollection }));
        }
      });
    } else {
      App.showView(new TasksDashboardView({ collection: this.tasksCollection }));
    }
  }
});

// Start router AFTER app starts
App.on("start", function () {
  console.log("Router starting");

  window.router = new AppRouter();

  if (!Backbone.History.started) {
    Backbone.history.start({pushState: true});
  }
});