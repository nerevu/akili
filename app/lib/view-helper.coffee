mediator = require 'mediator'
config = require 'config'
devconfig = require 'devconfig'

# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
utils = require './utils'

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Partials
# ----------------------
register 'partial', (name, context) ->
  template = require "views/templates/partials/#{name}"
  new Handlebars.SafeString template context

# Map helpers
# -----------

# Make 'with' behave a little more mustachey.
register 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
register 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  utils.reverse routeName, params

# Conditional evaluation
# ----------------------
register 'if_active_factor', (factor, options) ->
  if mediator.active.factor is factor
    options.fn(this)
  else
    options.inverse(this)

register 'if_current', (item, cur_item, options) ->
  if item is cur_item then options.fn(this) else options.inverse(this)

# Other helpers
# -----------
register 'capitalize', (word) ->
  new Handlebars.SafeString s.capitalize word

# Convert date to day
register 'get_day', (date) ->
  day = if date[-2..-2] is '0' then date[-1..] else date[-2..]
  new Handlebars.SafeString day

# Loop n times
register 'times', (n, options) ->
  accum = ''
  i = 1
  x = n + 1

  while i < x
    accum += options.fn(i)
    i++

  accum
