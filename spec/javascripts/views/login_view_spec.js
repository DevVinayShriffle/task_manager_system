// Load browser-like environment
require('./setup_browser_env');

// Load your Rails JS file (no require)
loadScript('./app/assets/javascripts/app/views/login_view.js');

describe("LoginView - Successful login", function() {
  let view;

  beforeEach(function(){
    view = new window.LoginView();
    view.render();
    $("body").append(view.el);

    spyOn(window, "TaskCollection").and.callFake(function(){
      return { fetch: function(options){ options.success(); } };
    });
  });

  afterEach(function(){
    view.remove();
    $("body").empty();
  });

  it("should login successfully", function(){
    view.$('#email').val("test@gmail.com");
    view.$('#password').val("Test@123");

    spyOn($, "ajax").and.callFake(function(options) {
      options.success({ meta: { token: "abc123" } });
    });

    spyOn(localStorage, "setItem");

    view.$("#loginForm").trigger("submit");

    expect(localStorage.setItem).toHaveBeenCalledWith("token", "abc123");
    expect(router.navigate).toHaveBeenCalledWith("users/tasks", { trigger: true });
  });
});