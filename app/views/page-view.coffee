View = require 'views/base/view'
template = require 'views/templates/page'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PageView extends View
  autoRender: true
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) =>
    super
    utils.log 'initializing main view'
    @content = options.content

  render: =>
    super

  getTemplateData: =>
    utils.log 'get page view template data'
    templateData = super
    templateData.content = @content
    templateData
