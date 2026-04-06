window.TaskModel = Backbone.Model.extend({
  urlRoot: "/users/tasks",
  defaults: {
    title: "",
    descryption: "",
    status: "pending"
  }
});