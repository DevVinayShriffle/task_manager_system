const { JSDOM } = require('jsdom');
const fs = require('fs');
const vm = require('vm');

// Create a jsdom window
const dom = new JSDOM('<!doctype html><html><body></body></html>', { url: "http://localhost" });
global.window = dom.window;
global.document = dom.window.document;
global.navigator = dom.window.navigator;

// Attach jQuery
global.$ = require('jquery')(dom.window);

// Backbone + Marionette
const Backbone = require('backbone');
const Marionette = require('backbone.marionette');
global.Backbone = Backbone;
global.Marionette = Marionette;

// Mock Rails stuff
global.JST = {};
global.localStorage = { setItem: jasmine.createSpy('setItem') };
global.router = { navigate: jasmine.createSpy('navigate') };

// Load plain JS files into Node environment
global.loadScript = function(filePath) {
  const code = fs.readFileSync(filePath, 'utf-8');
  vm.runInThisContext(code, { filename: filePath });
};