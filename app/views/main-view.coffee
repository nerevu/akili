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
    @options = _.clone(options)
    @options.parent = '#map'
    @options.selection = '#map svg'
    @choropleth = new Choropleth @options
    @choropleth.init @options
    @delegate 'change', '#factor', @getFactor
    mediator.setActiveFactor options.factor

  render: =>
    super
    _.defer @choropleth.makeChart

  getFactor: =>
    factor = @.$('#factor-form').serializeArray()[0].value.toLowerCase()
    utils.redirectTo url: "home/#{factor}"

  getTemplateData: =>
    utils.log 'get main view template data'
    templateData = super
    templateData.colors = @choropleth.getColors()
    templateData.min = @choropleth.extent[0]
    templateData.max = @choropleth.extent[1]
    templateData.percent = @choropleth.getPercent()
    templateData.level = @options.level
    templateData.levels = @options.levels
    templateData.factor = @options.factor
    templateData.factors = @options.factors
    templateData
