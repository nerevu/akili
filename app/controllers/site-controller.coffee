Controller = require 'controllers/base/controller'
MainView = require 'views/main-view'
config= require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    utils.log "initialize site-controller"
    @factor = params?.factor ? config.default.factor
    @coloredLevel = params?.level ? config.default.level

  index: (params) => @reuse "#{@factor}:#{@coloredLevel}", =>
    utils.log "index site-controller"
    @title = config.site.home.title
    @url = utils.reverse 'site#index', params
    @active = config.site.home.page
    allLevels = ['county', 'state']
    shownLevels = if @coloredLevel is 'state' then ['state'] else allLevels

    options =
      factor: @factor
      model: @risks.findWhere factor: @factor
      risks: @risks.pluck 'factor'
      topology: @topology.get 'topology'
      names: @names.findWhere(type: @coloredLevel).get 'names'
      allLevels: allLevels
      shownLevels: shownLevels
      coloredLevel: @coloredLevel

    @viewPage MainView, options

  viewPage: (theView, options) =>
    @adjustTitle @title
    mediator.setUrl @url
    utils.log @title, 'pageview'
    @view = new theView options
