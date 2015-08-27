debug =
  mobile: false
  production: false

time =
  development:
    scroll: 750  # in ms
    logger: 5000  # in ms
    max_cache: 12  # in hours

  production:
    scroll: 750
    logger: 5000
    max_cache: 24  # in hours

enable =
  development:
    logger: local: true, remote: false
    tracker: false
    toobusy: false

  production:
    logger: local: true, remote: false
    tracker: true
    toobusy: true

  testing:
    logger: local: false, remote: false
    tracker: false
    toobusy: false

urls =
  development:
    logger: 'http://localhost:8888/v1/log'
    tracker: 'http://www.google-analytics.com/collect'

  production:
    logger: 'http://flogger.herokuapp.com/v1/log',
    tracker: 'http://www.google-analytics.com/collect'

cache_timeout =
  development: 12 # in hours
  production: 24 # in hours

# verbosity levels
# 1 = debug
# 2 = info
# 3 = warn
# 4 = error
# 5 = pageview
# 6 = screenview
# 7 = event
# 8 = transaction
# 9 = item
# 10 = social

# run when verbosity is this or higher
verbosity =
  development:
    logger: local: 1, remote: 4
    tracker: 5

  production:
    logger: local: 2, remote: 4
    tracker: 5

host = window?.location?.hostname ? require('os').hostname()
localhost = host in ['localhost', 'tokpro.local', 'tokpro']
ua = navigator?.userAgent
list = 'iphone|ipod|ipad|android|blackberry|opera mini|opera mobi'
mobile_device = (/"#{list}"/).test ua?.toLowerCase()

if mocha? or mochaPhantomJS?
  environment = 'testing'
  storage_mode = 'file'
else if localhost and not debug.production
  environment = 'development'
  storage_mode = 'remote'
else
  environment = 'production'
  storage_mode = 'remote'

mobile = debug.mobile or mobile_device
console.log "#{environment} environment set"
console.log "host: #{host}" if host
console.log "mobile device: #{mobile}"
console.log "storage mode: #{storage_mode}"

devconfig =
  ########################
  # Development Settings #
  ########################
  storage:
    file: storage_mode is 'file'
    local: storage_mode is 'local'
    remote: storage_mode is 'remote'
  localhost: localhost
  dev: environment is 'development'
  prod: environment is 'production'
  testing: environment is 'testing'
  verbosity: verbosity[environment]
  urls: urls[environment]
  enable: enable[environment]
  time: time[environment]
  ua: ua
  mobile: mobile

module.exports = devconfig
