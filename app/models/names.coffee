Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
data = require 'data/names'

module.exports = class Names extends Collection
  model: Model
  type: 'names'
  file: true
  local: false
  remote: false

  initialize: (options) =>
    super
    @url = "data/#{@type}"

  parse: (resp) =>
    utils.log "parsing #{@type} resp"

    for model in resp
      if model.type is config.default.level
        res = model.names
        break

    res

  fetch: =>
    utils.log "fetch Names collection"
    @set data
