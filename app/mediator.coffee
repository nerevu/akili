mediator = module.exports = Chaplin.mediator

mediator.setActiveFactor = (factor) ->
  mediator.active.factor = factor
  mediator.publish 'activeFactor', factor

mediator.setUrl = (url) ->
  console.log "mediator.url is #{url}"
  mediator.url = url

mediator.setSynced = (type, response) ->
  console.log "#{type} data synced!!"
  mediator.synced[type] = true
  mediator.publish "synced:#{type}", response
