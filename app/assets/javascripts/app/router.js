var AppRouter = Marionette.AppRouter.extend({
  appRoutes: {
    "": "showLogin",
    "tasks": "showTasks"
  }
});

var Controller = {
  showLogin: function () {
    App.showView(new LoginView());
  },

  showTasks: function () {
    var tasks = new TaskCollection();

    tasks.fetch({
      success: function () {
        App.showView(new TaskListView({ collection: tasks }));
      }
    });
  }
};

App.on("start", function () {
  new AppRouter({ controller: Controller });
});