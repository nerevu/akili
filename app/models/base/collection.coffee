Model = require './model'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  _.extend @prototype, Chaplin.SyncMachine
  model: Model

  initialize: (models, options) ->
    super
    utils.log "initialize #{@type} collection", 'info'
    @synced @afterSynced

  afterSynced: =>
    mediator.setSynced @
    utils.log "#{@type} collection:"
    utils.log @

  reset: (models, options) =>
    super(models, options)

  fetch: (options) =>
    utils.log "fetching #{@type} collection"
    @beginSync()

    options = if options then _.clone(options) else {}
    success = options.success
    options.parse = options?.parse ? true
    options.success = (resp) => @processResp resp, options, success
    @wrapError options

    if @file
      utils.log "loading #{@type} collection from file"
      @filesync @, options
    else if @local or @remote
      utils.log "loading #{@type} collection from localStorage" if @local
      utils.log "loading #{@type} collection from server" if @remote
      @sync 'read', @, options

  parse: (resp) =>
    utils.log "parsing #{@type} resp"
    resp.objects

  processResp: (resp, options=null, success=null) =>
    # return if @disposed
    options = options or {}
    utils.log "#{@type} success"
    method = if options.reset then 'reset' else 'set'
    @[method] resp, options
    success @, resp, options if success
    @finishSync()

  wrapError: (options) =>
    error = options.error
    options.error = (resp) =>
      error @, resp, options if error
      @unsync()

  urlError: ->
    throw new Error 'A "url" property or function must be specified'

  filesync: (collection, options) ->
    requireData = (options) -> require options.url

    $.Deferred((deferred) ->
      if not options.url
        url = _.result(collection, 'url') or urlError()
        deferred.reject if not url

      resp = requireData _.extend {url}, options
      collection.trigger 'request', collection, resp, options
      options.success resp
      deferred.resolve resp
    ).promise()
