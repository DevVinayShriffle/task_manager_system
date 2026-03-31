// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"
//= require backbone.marionette
import { App } from "./app";

document.addEventListener("DOMContentLoaded", () => {
  App.start();
});
