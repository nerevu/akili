# External dependencies
express = require 'express'
winston = require 'winston'
morgan = require 'morgan'
bodyParser = require 'body-parser'
compression = require 'compression'
timeout = require 'connect-timeout'

# Set clients
transports = []
app = express()

transports.push new winston.transports.Console {colorize: true}
options = {filename: 'server.log', maxsize: 2097152}
transports.push new winston.transports.File options
logger = new winston.Logger {transports: transports}

# Set variables
encoding = {encoding: 'utf-8'}
maxCacheAge = 10 * 1000
serverTimeout = 25 * 1000 # server timeout (in milliseconds)

# other
port = process.env.PORT or 3333

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
winstonStream = {write: (message, encoding) -> logger.info message}
app.use timeout serverTimeout
app.use morgan 'combined', {stream: winstonStream}
app.use haltOnTimedout
app.use bodyParser.text()
app.use haltOnTimedout
app.use compression()
app.use haltOnTimedout
app.use express.static __dirname + '/public', {maxAge: maxCacheAge}
app.use haltOnTimedout

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

  if ~req.get('Host').indexOf('localhost')
    newUrl = "#{req.protocol}://#{req.get('Host')}/##{req.url}"
  else
    newUrl = "https://#{req.get('Host')}/##{req.url}"

  res.redirect newUrl

# create server routes
app.all '*', configCORS
app.get '*', configPush

# timeout err handler
app.use (err, req, res, next) ->
  logError err, 'app'
  sendError err, res, 'app', 504

# start server
server = app.listen port, ->
  logger.info "Listening on port #{port}"

process.on 'SIGINT', ->
  server.close()
  process.exit()
