var API = {
  request: function (options) {
    var token = localStorage.getItem("token");

    return $.ajax({
      url: options.url,
      method: options.method || "GET",
      data: options.data,
      headers: {
        Authorization: token
      }
    });
  }
};