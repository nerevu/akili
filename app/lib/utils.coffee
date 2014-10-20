devconfig = require 'devconfig'
config = require 'config'
mediator = require 'mediator'

# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils
ml_options =
  url: devconfig.logger_url
  interval: devconfig.logger_interval

Minilog
  .enable()
  .pipe new Minilog.backends.jQuery ml_options

logger = Minilog config.site.id

_.extend utils,
  # Logging helper
  # ---------------------
  _getPriority: (level) ->
    switch level
      when 'debug' then 1
      when 'info' then 2
      when 'warn' then 3
      when 'error' then 4
      when 'pageview' then 5
      when 'screenview' then 6
      when 'event' then 7
      when 'transaction' then 8
      when 'item' then 9
      when 'social' then 10
      else 0

  log: (message, level='info', options=null) ->
    priority = @_getPriority level
    options = options ? {}

    if devconfig.prod and priority < devconfig.tracking_priority
      switch devconfig.verbosity
        when 1 then console.log message if priority > 2
        when 2 then console.log message if priority > 1
        when 3 then console.log message if priority > 0
    else if priority < devconfig.tracking_priority
      switch devconfig.verbosity
        when 0 then console.log message if priority > 2
        when 1 then console.log message if priority > 1
        when 2 then console.log message if priority > 0
        when 3 then console.log message

    logging = devconfig.prod or devconfig.debug_logger
    tracking = (devconfig.prod or devconfig.debug_tracker)
    tracking = tracking and config.google.analytics_tracking_id

    if (logging or tracking) and priority >= devconfig.logging_priority
      user_options =
        time: (new Date()).getTime()
        user: mediator?.user?.get('email')

    pass = devconfig.tracking_priority > priority >= devconfig.logging_priority

    if logging and pass
      text = JSON.stringify message
      message = if text.length > 512 then "size exceeded" else message
      data = _.extend {message: message}, user_options
      logger[level] data
    else if tracking and priority >= devconfig.tracking_priority
      ga (tracker) ->
        hit_options =
          v: 1
          tid: config.google.analytics_tracking_id
          cid: tracker.get 'clientId'
          uid: mediator?.user?.get('id')
          # uip: ip address
          dr: document.referrer or 'direct'
          ua: devconfig.ua
          gclid: config.google.adwords_id
          dclid: config.google.displayads_id
          sr: "#{screen.width}x#{screen.height}"
          vp: "#{$(window).width()}x#{$(window).height()}"
          t: level
          an: config.site.title
          aid: config.site.id
          av: config.site.version
          dp: mediator.url
          dh: document.location.hostname
          dt: message

        switch level
          when 'event'
            hit_options = _.extend hit_options,
              ec: options.category
              ea: options.action
              ev: options?.value
              el: options?.label ? 'N/A'

          when 'transaction'
            hit_options = _.extend hit_options,
              ti: options.trxn_id
              tr: options?.amount ? 0
              ts: options?.shipping ? 0
              tt: options?.tax ? 0
              cu: options?.cur ? 'USD'
              ta: options?.affiliation ? 'N/A'

          when 'item'
            hit_options = _.extend hit_options,
              ti: options.trxn_id
              in: options.name
              ip: options?.amount ? 0
              iq: options?.qty ? 1
              cu: options?.cur ? 'USD'
              ic: options?.sku ? 'N/A'
              iv: options?.category ? 'N/A'

          when 'social'
            hit_options = _.extend hit_options,
              sn: options?.network ? 'facebook'
              sa: options?.action ? 'like'
              st: options?.target ? mediator.url

        if level is 'experiment'
          hit_options = _.extend hit_options,
            xid: options.xid
            xvar: options?.xvar ? 'A'

        data = _.extend options, user_options, hit_options
        $.post devconfig.analytics_url, data

# Prevent creating new properties and stuff.
Object.seal? utils
module.exports = utils
