Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
data = require 'data/risk_factors'

module.exports = class Risks extends Collection
  model: Model
  type: 'risk_factors'
  file: true
  local: false
  remote: false

  initialize: (options) =>
    super
    @url = "data/#{@type}"

  parse: (resp) =>
    utils.log "parsing #{@type} resp"

    for model in resp
      if model.factor is config.default.factor
        res = model[config.default.level]
        break

    res

  fetch: =>
    utils.log "fetch Risks collection"
    @set data
