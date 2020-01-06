utils = require 'lib/utils'

# Application routes.
module.exports = (match) ->
  match '', 'site#index'
  match 'app', 'site#index'
  match 'app/:factor', 'site#index'
  match 'app/:factor/:level', 'site#index'
  match ':page', 'site#show'
