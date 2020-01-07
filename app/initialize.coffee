Application = require 'application'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  new Application {
    controllerSuffix: '-controller'
    routes: routes
    pushState: true
  }
