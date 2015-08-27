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

  initialize: (options) ->
    super
    utils.log 'initializing navbar view'
    @delegate 'click', @collapseNav

  render: ->
    super
    utils.log 'rendering navbar view'

  collapseNav: (e) ->
    if e.target.href? and e.currentTarget.parentElement.id is 'navbar'
      $('.navbar-collapse').collapse('hide')

  getTemplateData: =>
    utils.log 'get navbar view template data'
    templateData = super
    templateData.site = config.site
    templateData
