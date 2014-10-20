utils = require 'lib/utils'

# Application routes.
module.exports = (match) ->
  match '', 'site#index'
  match ':factor', 'site#index'
  match ':factor/:level', 'site#index'
