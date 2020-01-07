mediator = module.exports = Chaplin.mediator

mediator.setActiveMap = (map) ->
  mediator.active.map = map
  mediator.publish 'activeMap'

mediator.setActiveFactor = (factor) ->
  mediator.active.factor = factor
  mediator.publish 'activeFactor', factor

mediator.setUrl = (url) ->
  mediator.url = url

mediator.setSynced = (response) ->
  mediator.synced = true
  mediator.publish "synced", response
