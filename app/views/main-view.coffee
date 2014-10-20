View = require 'views/base/view'
template = require 'views/templates/home'
config = require 'config'
utils = require 'lib/utils'
makeChoropleth = require 'lib/makechoropleth'

module.exports = class MainView extends View
  autoRender: true
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) =>
    super
    utils.log 'initializing main view'
    @level = options.level
    options.selection = ".choropleth svg"
    options.data = @model.get "#{@level}"
    _.defer makeChoropleth, options

  render: =>
    super

  getTemplateData: =>
    utils.log 'get main view template data'
    templateData = super
    templateData.level = @level
    templateData
