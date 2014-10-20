mediator = module.exports = Chaplin.mediator

mediator.setActive = (page) ->
  mediator.active = page
  mediator.publish 'activeNav'

mediator.setUrl = (url) ->
  mediator.url = url
