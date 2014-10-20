Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
data = require 'data/risk_factors'

module.exports = class Risks extends Collection
  model: Model

  fetch: =>
    utils.log "fetch Risks collection"
    @set data
