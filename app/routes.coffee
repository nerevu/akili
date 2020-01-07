utils = require 'lib/utils'

# Application routes.
module.exports = (match) ->
  match '', 'site#index'
  match ':page', 'site#show'
  match ':factor', 'site#index'
  match ':factor/:level', 'site#index'
