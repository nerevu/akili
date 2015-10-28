Controller = require 'controllers/base/controller'
MainView = require 'views/main-view'
config= require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    utils.log "initialize site-controller"
    @factor = params?.factor ? config.default.factor
    @title = config.site.home.title

  getOptions: =>
    options =
      collection: @collection
      factor: @factor
      factors: config.default.factors
      topology: @topology.get 'topology'
      names: @names.toJSON()
      level: config.default.level
      levels: config.default.levels
      data: @collection.toJSON()
      idAttr: config.default.id_attr
      nameAttr: config.default.name_attr
      metricAttr: config.default.metric_attr

  show: (params) => @reuse @factor, =>
    utils.log "home site-controller"
    @url = utils.reverse 'site#show', params

    if mediator.synced.food
      @viewPage @getOptions()
    else
      @subscribeEvent 'synced:food', -> @viewPage @getOptions()

  viewPage: (options) =>
    @adjustTitle @title
    mediator.setUrl @url
    utils.log @title, 'pageview'
    @view = new MainView options
