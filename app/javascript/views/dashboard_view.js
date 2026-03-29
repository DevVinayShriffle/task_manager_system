export var DashboardView = Backbone.View.extend({
    el: '#app',

    template: _.template($("#dashboard-template").html()),

    events: {
        "click #logout-button":"logoutUser",
        "click #create-task-btn":"createTask"
    },

    render: function () {
        this.$el.html(this.template());
    },

    logoutUser: function () {
        localStorage.removeItem("token");
        Backbone.history.navigate("login", {trigger: true});
    },

    createTask: function () {
        alert("Task creation clicked (Api)");
    }
});