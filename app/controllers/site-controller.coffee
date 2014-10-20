Controller = require 'controllers/base/controller'
MainView = require 'views/main-view'
config= require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class SiteController extends Controller
  index: (params) =>
    utils.log "index site-controller"
    title = config.site.main.title

    @adjustTitle title
    mediator.setActive config.site.main.page
    mediator.setUrl utils.reverse 'site#index', params
    utils.log title, 'pageview'

    @view = new MainView
      model: @risks.findWhere factor: params?.factor ? config.default.factor
      level: params?.level ? config.default.level
