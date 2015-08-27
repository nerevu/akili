SiteView = require 'views/site-view'
FooterView = require 'views/footer-view'
NavbarView = require 'views/navbar-view'
config= require 'config'
mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
  risks: mediator.risks
  topology: mediator.topology
  names: mediator.names

  # Reusabilities persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: ->
    @reuse 'site', SiteView
    @reuse 'site-footer', FooterView
    @reuse 'navbar', NavbarView

    author = config.author
    description = config.description
    keywords = config.keywords
    title = config.site.title
    url = config.site.url
    type = config.site.type
    app_id = config.facebook.app_id

    # SEO
    $('head').append("<meta name='author' content='#{author}'>")
    $('head').append("<meta name='description' content='#{description}'>")
    $('head').append("<meta name='keywords' content='#{keywords}'>")

    # Open Graph
    $('head').append("<meta property='og:site_name' content='#{title}'>")
    $('head').append("<meta property='og:url' content='#{url}'>")
    $('head').append("<meta property='og:type' content='#{type}'>")
    $('head').append("<meta property='fb:app_id' content='#{app_id}'>")
