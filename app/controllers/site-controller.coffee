Controller = require 'controllers/base/controller'
MainView = require 'views/main-view'
config= require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    utils.log "initialize site-controller"
    @title = config.site.title

  getOptions: =>
    options =
      collection: @collection
      topology: @topology.get 'topology'
      names: @names.toJSON()
      data: @collection.toJSON()

  show: (params) =>
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
