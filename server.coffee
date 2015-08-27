# Usage: coffee server.coffee

# External dependencies
express = require 'express'
toobusy = require 'toobusy-js'
winston = require 'winston'
papertrail = require('winston-papertrail').Papertrail
morgan = require 'morgan'
bodyParser = require 'body-parser'
compression = require 'compression'
timeout = require 'connect-timeout'

# Local dependencies
config = require './app/config.coffee'
devconfig = require './app/devconfig.coffee'

# nodetime
if process.env.NODETIME_ACCOUNT_KEY
  require('nodetime').profile
    accountKey: process.env.NODETIME_ACCOUNT_KEY
    appName: config.site.title

# Set variables
port = process.env.PORT or 3333
encoding = {encoding: 'utf-8'}
cache_days = 5
max_cache_age = cache_days * 24 * 60 * 60 * 1000
sv_timeout = 250 * 1000  # server timeout (in milliseconds)
sv_retry_after = 5 * 1000 # toobusy wait time between requests (in milliseconds)

# Set clients
transports = []
app = express()

if devconfig.dev
  transports.push new winston.transports.Console {colorize: true}
  options = {filename: 'server.log', maxsize: 2097152}
  transports.push new winston.transports.File options
else
  host = 'logs.papertrailapp.com'
  options = {handleExceptions: true, host: host, port: 55976, colorize: true}
  transports.push new papertrail options

logger = new winston.Logger {transports: transports}

# helper functions
logError = (err, src, error=true) ->
  logFun = if error then logger.error else logger.warn
  message = if src then "#{src}: #{err.message}" else err.message
  logFun message

sendError = (err, res, src, code=500) ->
  message = if src then "#{src}: #{err.message}" else err.message
  res.status(code).send {error: err.message}

haltOnTimedout = (req, res, next) -> if !req.timedout then next()

# middleware
# pipe web server logs through winston
winstonStream = {write: (message, encoding) -> logger.info message}
app.use timeout sv_timeout
app.use morgan 'combined', {stream: winstonStream}
app.use haltOnTimedout
app.use bodyParser.text()
app.use haltOnTimedout
app.use compression()
app.use haltOnTimedout
app.use express.static __dirname + '/public', {maxAge: max_cache_age}
app.use haltOnTimedout

# toobusy err handler
app.use (req, res, next) ->
  return next() if not toobusy() or not devconfig.enable.toobusy
  res.setHeader 'Retry-After', sv_retry_after
  res.location req.url
  err = {message: "server too busy. try #{req.url} again later."}
  logError err, 'app', false
  sendError err, res, 'app', 503

# CORS support
configCORS = (req, res, next) ->
  # logger.info "Configuring CORS"
  if not req.get 'Origin' then return next()
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
  res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With, Content-Type'
  if 'OPTIONS' is req.method then return res.send 200
  next()

# pushState hack
configPush = (req, res, next) ->
  if 'api' in req.url.split('/') then return next()
  newUrl = req.protocol + '://' + req.get('Host') + '/#' + req.url
  res.redirect newUrl

# create server routes
app.all '*', configCORS
app.get '*', configPush

# timeout err handler
app.use (err, req, res, next) ->
  logError err, 'app'
  sendError err, res, 'app', 504

# start server
server = app.listen port, -> logger.info "Listening on port #{port}"

process.on 'SIGINT', ->
  server.close()
  toobusy.shutdown()
  process.exit()
