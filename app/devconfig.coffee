debug_mobile = false
debug_production = false
debug_logger = false
debug_tracker = false
analytics_url = 'http://www.google-analytics.com/collect'

# verbosity levels
# 0 = quiet (dev: warn or higher, prod: none)
# 1 = normal (dev: info or higher, prod: warn or higher)
# 2 = verbose (dev: debug or higher, prod: info or higher)
# 3 = very verbose (dev: all, prod: debug or higher)
verbosity = 1

# priority levels
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

logger_interval = 5000
logging_priority = 2
tracking_priority = 5

host = window?.location?.hostname ? require('os').hostname()
localhost = host in ['localhost', 'tokpro.local', 'tokpro']
ua = navigator?.userAgent
list = 'iphone|ipod|ipad|android|blackberry|opera mini|opera mobi'
mobile_device = (/"#{list}"/).test ua?.toLowerCase()

if mocha? or mochaPhantomJS?
  environment = 'testing'
  storage_mode = 'file'
  logger_url = ''
else if localhost and not debug_production
  environment = 'development'
  storage_mode = 'dualsync'
  logger_url = 'http://localhost:8888/v1/log'
  stale_age = 72 # in hours
else
  environment = 'production'
  storage_mode = 'file'
  logger_url = 'http://flogger.herokuapp.com/v1/log'
  stale_age = 12 # in hours

mobile = debug_mobile or mobile_device
console.log "#{environment} environment set"
console.log "host: #{host}" if host
console.log "verbosity: #{verbosity}"
console.log "mobile device: #{mobile}"
console.log "storage mode: #{storage_mode}"

devconfig =
  ########################
  # Development Settings #
  ########################
  file_storage: storage_mode is 'file'
  dual_storage: storage_mode is 'dualsync'
  localhost: localhost
  prod: environment is 'production'
  dev: environment is 'development'
  debug_logger: debug_logger
  debug_tracker: debug_tracker
  testing: environment is 'testing'
  verbosity: verbosity
  logger_url: logger_url
  analytics_url: analytics_url
  logger_interval: logger_interval
  logging_priority: logging_priority
  tracking_priority: tracking_priority
  ua: ua
  mobile: mobile

module.exports = devconfig
