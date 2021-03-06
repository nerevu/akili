Model = require 'models/base/model'
utils = require 'lib/utils'
topology = require 'data/topology'

module.exports = class Topology extends Model
  fetch: =>
    utils.log "fetch Topology model"
    @set topology: topology
