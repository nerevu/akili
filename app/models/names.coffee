Collection = require 'models/base/collection'
Model = require 'models/base/model'
utils = require 'lib/utils'
config = require 'config'

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
    resp
