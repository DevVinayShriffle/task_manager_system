window.TasksDashboardView = Marionette.View.extend({
  template: JST["app/templates/tasks_dashboard"],

  events: {
    "submit #taskForm": "saveTask",
    "click .edit-task": "editTask"
  },

  collectionEvents: {
    "add remove change reset": "render" // <-- auto re-render on collection changes
  },

  initialize: function () {
    this.collection = this.collection || new TaskCollection();
    this.listenTo(this.collection, "update reset", this.render);
    this.collection.fetch();
  },

  templateContext: function() {
    return {
      collection: this.collection
    };
  },

  saveTask: function (e) {
    e.preventDefault();
    var title = this.$("#taskTitle").val();
    var descryption = this.$("#taskDescryption").val();

    this.collection.create({ title: title, descryption: descryption }, {
      wait: true,
      success: function() { console.log("Task saved"); }
    });
  },

  editTask: function (e) {
    var id = $(e.currentTarget).data("id");
    var task = this.collection.get(id);
    console.log("id ",id)
    if (task) {
      this.$("#taskTitle").val(task.get("title"));
      this.$("#taskDescryption").val(task.get("descryption"));
      // task.destroy({ wait: true });
    }
  }
});