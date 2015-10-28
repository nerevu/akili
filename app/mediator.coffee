mediator = module.exports = Chaplin.mediator

mediator.setUrl = (url) ->
  console.log "mediator.url is #{url}"
  mediator.url = url

mediator.setSynced = (type, response) ->
  console.log "#{type} data synced!!"
  mediator.synced[type] = true
  mediator.publish "synced:#{type}", response
