utils = require 'lib/utils'

# Application routes.
module.exports = (match) ->
  match '', 'site#show'
  match 'home', 'site#show'
