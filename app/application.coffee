mediator = require 'mediator'
Risks = require 'models/risks'
Topology = require 'models/topology'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: config.site.title

  start: =>
    # You can fetch some data here and start app by calling `super` after that.
    mediator.risks.fetch()
    mediator.topology.fetch()
    cookie_domain = if devconfig.localhost then {cookieDomain: 'none'} else 'auto'
    ga 'create', config.google.analytics_tracking_id, cookie_domain
    ga 'require', 'displayfeatures'
    super

  # Create additional mediator properties.
  initMediator: ->
    # Add additional application-specific properties and methods
    utils.log 'initializing mediator'
    mediator.risks = new Risks()
    mediator.topology = new Topology()
    mediator.active = null
    mediator.url = null
    mediator.seal()
    super
