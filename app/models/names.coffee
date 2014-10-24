Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
data = require 'data/names'

module.exports = class Names extends Collection
  model: Model

  fetch: =>
    utils.log "fetch Names collection"
    @set data
