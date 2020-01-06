mediator = require 'mediator'
Risks = require 'models/risks'
Topology = require 'models/topology'
Names = require 'models/names'
config = require 'config'
utils = require 'lib/utils'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: config.site.title

  start: =>
    # You can fetch some data here and start app by calling `super` after that.
    mediator.risks.fetch()
    mediator.topology.fetch()
    mediator.names.fetch()
    utils.ga()
    super

  # Create additional mediator properties.
  initMediator: ->
    # Add additional application-specific properties and methods
    utils.log 'initializing mediator'
    mediator.risks = new Risks()
    mediator.topology = new Topology()
    mediator.names = new Names()
    mediator.synced = false
    mediator.active = {}
    mediator.url = null
    mediator.seal()
    super
