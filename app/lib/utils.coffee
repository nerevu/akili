devconfig = require 'devconfig'
config = require 'config'
mediator = require 'mediator'

# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils
chaplin_utils = new ChapinUtils
  mediator: mediator
  site: config.site
  enable: devconfig.enable
  verbosity: devconfig.verbosity
  urls: devconfig.urls
  localhost: devconfig.localhost
  ua: devconfig.ua
  log_interval: devconfig.time.logger
  google: config.google

chaplin_utils.init()

_.extend utils,
  jqueryEvents: chaplin_utils.JQUERY_EVENTS
  changeURL: chaplin_utils.changeURL
  smoothScroll: chaplin_utils.smoothScroll
  log: chaplin_utils.log
  ga: chaplin_utils.initGA
  filterFeed: chaplin_utils.filterCollection
  makeFilterer: chaplin_utils.makeFilterer
  makeComparator: chaplin_utils.makeComparator
  getTags: chaplin_utils.getTags
  checkIDs: chaplin_utils.checkIDs

# Prevent creating new properties and stuff.
Object.seal? utils
module.exports = utils
