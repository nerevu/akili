# https://github.com/hengkiardo/express-enforces-ssl

redirectUrl = (req, res) ->
  if req.method in ['GET', 'HEAD']
    res.redirect 301, "https://#{req.hostname}#{req.originalUrl}"
  else
    msg = 'Please use HTTPS when submitting data to this server.'
    res.status(403).send msg

module.exports = ->
  (req, res, next) ->
    isSecure = req.secure or req.hostname is 'localhost'

    # Heroku proxies requests to the app over http and puts the originating
    # request protocol in the header
    # https://stackoverflow.com/a/45698106/408556
    # https://stackoverflow.com/a/40896498/408556
    if not isSecure and req.get('X-Forwarded-Proto') is 'https'
      isSecure = req.get('X-Forwarded-Port') is '443'

    if isSecure then next() else redirectUrl req, res
