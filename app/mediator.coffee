mediator = module.exports = Chaplin.mediator

mediator.setActiveFactor = (factor) ->
  mediator.active.factor = factor
  mediator.publish 'activeFactor', factor

mediator.setUrl = (url) ->
  console.log "mediator.url is #{url}"
  mediator.url = url

mediator.setSynced = (response) ->
  console.log "data synced!!"
  mediator.synced = true
  mediator.publish "synced", response
