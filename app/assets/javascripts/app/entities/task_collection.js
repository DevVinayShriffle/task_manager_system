window.TaskCollection = Backbone.Collection.extend({
  model: TaskModel,
  url: "/users/tasks",
  parse: function(res){
  	return res.tasks || [];
  }
});