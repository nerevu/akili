View = require 'views/base/view'
template = require 'views/templates/navbar'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class NavbarView extends View
  autoRender: true
  className: 'container'
  region: 'navbar'
  template: template
  listen: 'activeNav mediator': 'render'

  initialize: (options) =>
    super
    utils.log 'initializing navbar view'

  render: ->
    super
    utils.log 'rendering navbar view'

  getTemplateData: =>
    utils.log 'get navbar view template data'
    templateData = super
    templateData.main = config.site.main
    templateData.pages = config.site.pages
    templateData.site = config.site.name
    templateData
