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

    if @file
      @url = "data/#{@type}"
    else
      api = 'https://data.hdx.rwlabs.org/api/action'
      rid = 'b5b850a5-76da-4c33-a410-fd447deac042'
      raw = '{"adm0_name": "Kenya", "mp_year": 2015.0, "mp_month": "3"}'
      f = encodeURIComponent raw
      @url = "#{api}/datastore_search?resource_id=#{rid}&filters=#{f}&limit=999"

  parse: (resp) =>
    utils.log "parsing #{@type} resp"
    resp.result.records
