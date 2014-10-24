mediator = require 'mediator'
devconfig = require 'devconfig'

# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
utils = require './utils'

register = (name, fn) ->
  Handlebars.registerHelper name, fn

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
register 'if_active_page', (page, options) ->
  if mediator.active.page is page then options.fn(this) else options.inverse(this)

register 'if_active_map', (map, options) ->
  if mediator.active.map is map then options.fn(this) else options.inverse(this)

register 'if_active_factor', (factor, options) ->
  if mediator.factor is factor then options.fn(this) else options.inverse(this)

register 'if_current', (item, cur_item, options) ->
  if item is cur_item then options.fn(this) else options.inverse(this)

# Other helpers
# -----------
# Convert date to day
register 'get_day', (date) ->
  day = if date[-2..-2] is '0' then date[-1..] else date[-2..]
  new Handlebars.SafeString day

# Loop n times
register 'times', (n, block) ->
  accum = ''
  i = 1
  x = n + 1

  while i < x
    accum += block.fn(i)
    i++

  accum
