View = require 'views/base/view'
template = require 'views/templates/footer'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class FooterView extends View
  autoRender: true
  className: 'row'
  region: 'footer'
  template: template

  initialize: (options) =>
    super
    utils.log 'initializing footer view'

  render: ->
    super
    utils.log 'rendering footer view'

  getTemplateData: =>
    utils.log 'get footer view template data'
    templateData = super
    templateData.author = config.author
    templateData.site = config.site
    templateData.year = new Date().getFullYear()
    templateData
