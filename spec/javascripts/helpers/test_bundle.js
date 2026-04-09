// test_bundle.js

// 1. Setup jsdom environment
const { JSDOM } = require('jsdom');
const dom = new JSDOM('<!doctype html><html><body></body></html>');

global.window = dom.window;
global.document = dom.window.document;
global.navigator = dom.window.navigator;

// 2. Setup jQuery
const jQuery = require('jquery')(dom.window);
global.$ = jQuery;

// 3. Setup Backbone + Marionette
const Backbone = require('backbone');
const Marionette = require('backbone.marionette');

global.Backbone = Backbone;
global.Marionette = Marionette;

// 4. Mock browser-specific things
global.JST = {}; // templates
global.localStorage = { setItem: () => {} };
global.router = { navigate: () => {} };

// 5. Load your app JS files AFTER setting globals
require('../../app/assets/javascripts/app/views/login_view.js');
require('../../app/assets/javascripts/app/entities/task_collection.js');
require('../../app/assets/javascripts/app/entities/task_model.js');