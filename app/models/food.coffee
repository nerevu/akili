Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
devconfig = require 'devconfig'

module.exports = class Food extends Collection
  model: Model
  type: 'food'
  file: devconfig.storage.file
  local: devconfig.storage.local
  remote: devconfig.storage.remote

  initialize: (options) =>
    super
    utils.log "initialize food collection", 'info'

    if @file
      @url = "data/#{@type}"
    else
      api = 'https://data.hdx.rwlabs.org/api/action'
      rid = 'b5b850a5-76da-4c33-a410-fd447deac042'
      @url = "#{api}/datastore_search?resource_id=#{rid}&q=kenya"

  parse: (resp) =>
    utils.log "parsing #{@type} resp"
    resp.result.records
