# Usage: coffee server.coffee

express = require 'express'
winston = require 'winston'
papertrail = require('winston-papertrail').Papertrail
morgan = require 'morgan'
bodyParser = require 'body-parser'
compression = require 'compression'
timeout = require 'connect-timeout'
helmet = require 'helmet'
history = require 'connect-history-api-fallback'

enforceSSL = require './app/lib/enforce-ssl'
config = require './app/config'
devconfig = require './app/devconfig'

port = process.env.PORT or 3333
maxCacheAge = devconfig.time.cache * 60 * 1000  # page cache (in ms)
svTimeout = devconfig.time.timeout * 1000  # server timeout (in ms)

transports = [
  new winston.transports.Console colorize: true
]

app = express()

staticFileMiddleware = express.static "#{__dirname}/public",
  maxAge: maxCacheAge

if devconfig.enable.logger.remote
  host = 'logs.papertrailapp.com'
  options =
    handleExceptions: true
    host: host
    port: 55976
    colorize: true

  transports.push(new papertrail options)

if devconfig.enable.logger.local
  options =
    filename: 'server.log'
    maxsize: 2097152

  transports.push(new winston.transports.File options)

logger = winston.createLogger transports: transports

logError = (err, src, error=true) ->
  logFun = if error then logger.error else logger.warn
  message = if src then "#{src} #{err.message}" else err.message
  logFun message

sendError = (err, res, src, code=500) ->
  res.status(code).send {error: err.message}

haltOnTimedout = (req, res, next) -> if !req.timedout then next()

winstonStream = write: (message, encoding) -> logger.info message

if devconfig.prod
  app.use enforceSSL()
  app.use helmet()

app.use staticFileMiddleware
app.use history()
app.use timeout svTimeout
app.use morgan 'combined', {stream: winstonStream}
app.use haltOnTimedout
app.use bodyParser.text()
app.use haltOnTimedout
app.use compression()
app.use haltOnTimedout
app.use staticFileMiddleware
app.use haltOnTimedout

app.use (err, req, res, next) ->
  logError err, 'app'
  sendError err, res, 'app', 504

server = app.listen port, -> logger.info "Listening on port #{port}"

process.on 'SIGINT', ->
  server.close()
  process.exit()
