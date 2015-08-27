# Base model.
module.exports = class Model extends Chaplin.Model
  # Mixin a synchronization state machine.
  # _.extend @prototype, Chaplin.SyncMachine
  # initialize: ->
  #   super
  #   @on 'request', @beginSync
  #   @on 'sync', @finishSync
  #   @on 'error', @unsync
