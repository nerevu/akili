Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
config = require 'config'

module.exports = class Risks extends Collection
  model: Model
  type: 'risks'
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
