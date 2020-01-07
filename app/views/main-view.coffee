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
    @options.data = @options.model.get options.coloredLevel
    @choropleth = new Choropleth @options
    @choropleth.init @options
    @delegate 'change', '#risk-factor', @getRiskFactor
    @delegate 'change', '#map-detail', @getMapDetail
    mediator.setActiveMap options.coloredLevel
    mediator.setActiveFactor options.factor

  render: =>
    super
    _.defer @choropleth.makeChart

  getRiskFactor: =>
    factor = @.$('#risk-form').serializeArray()[0].value.toLowerCase()
    utils.redirectTo url: "#{factor}/#{@options.coloredLevel}"

  getMapDetail: =>
    coloredLevel = @.$('#map-form').serializeArray()[0].value.toLowerCase()
    utils.redirectTo url: "#{@options.factor}/#{coloredLevel}"

  getTemplateData: =>
    factor = "#{@options.factor[0].toUpperCase()}#{@options.factor[1..]}"
    templateData = super
    templateData.colors = @choropleth.getColors()
    templateData.min = @choropleth.extent[0]
    templateData.max = @choropleth.extent[1]
    templateData.percent = @choropleth.getPercent()
    templateData.levels = @options.allLevels
    templateData.level = @options.coloredLevel
    templateData.factor = factor
    templateData.risks = @options.risks
    templateData
