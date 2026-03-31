# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "app", to: "app.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/entities", under: "entities"
pin_all_from "app/javascript/views", under: "views"
pin_all_from "app/javascript/entities", under: "entities"
pin "router", to: "router.js"