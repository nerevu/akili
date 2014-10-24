mediator = module.exports = Chaplin.mediator

mediator.setActivePage = (page) ->
  mediator.active.page = page
  mediator.publish 'activePage'

mediator.setActiveMap = (map) ->
  mediator.active.map = map
  mediator.publish 'activeMap'

mediator.setActiveFactor = (factor) ->
  mediator.active.factor = factor
  mediator.publish 'activeFactor'

mediator.setUrl = (url) ->
  mediator.url = url
