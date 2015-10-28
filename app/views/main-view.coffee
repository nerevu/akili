View = require 'views/base/view'
template = require 'views/templates/home'
config = require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'
Choropleth = require 'lib/choropleth'

module.exports = class MainView extends View
  autoRender: true
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) =>
    super
    utils.log 'initializing main view'
    @options = _.extend options, config.default
    @options.parent = '#map'
    @options.selection = '#map svg'
    @choropleth = new Choropleth @options
    @choropleth.init()

  render: =>
    super
    _.defer @choropleth.makeChart

  getTemplateData: =>
    utils.log 'get main view template data'
    templateData = super
    templateData.colors = @choropleth.colors
    templateData.min = @choropleth.extent[0]
    templateData.max = @choropleth.extent[1]
    templateData.percent = 100 / @choropleth.numColors
    templateData.description = config.site.description
    templateData
