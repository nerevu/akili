SiteView = require 'views/site-view'
FooterView = require 'views/footer-view'
NavbarView = require 'views/navbar-view'
config= require 'config'
mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
  risks: mediator.risks

  # Reusabilities persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: ->
    @reuse 'site', SiteView
    @reuse 'site-footer', FooterView
    @reuse 'navbar', NavbarView

    # SEO
    $('head').append("<meta name='author' content='#{config.author}'>")
    $('head').append("<meta name='description' content='#{config.description}'>")
    $('head').append("<meta name='keywords' content='#{config.keywords}'>")

    # Open Graph
    $('head').append("<meta property='og:site_name' content='#{config.site.title}'>")
    $('head').append("<meta property='og:url' content='#{config.site.url}'>")
    $('head').append("<meta property='og:type' content='#{config.site.type}'>")
    $('head').append("<meta property='fb:app_id' content='#{config.facebook.app_id}'>")
