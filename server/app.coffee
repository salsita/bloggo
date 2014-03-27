# Server
# ======
# This module is the entry point of the server application. So if you want to
# understand the codebase, it might be a good idea to start here.
#
require 'coffee-script'

path = require 'path'
require 'express-resource'
express = require 'express'

{log} = require './utils/logger'
config = require 'config'

app = express()

CLIENT_SECRET = "df237oh3vwoqnmqwuvbn2t732h2"

# Configure the server.
#
app.configure ->

  app.set 'port', process.env.PORT || 3000

  app.use express.bodyParser()
  app.use express.cookieParser process.env.CLIENT_SECRET or CLIENT_SECRET
  app.use express.methodOverride()

  app.use express.session {
    secret: process.env.CLIENT_SECRET or CLIENT_SECRET
    cookie:
      secure: false
      maxAge: 86400000
  }

  app.use express.favicon()
  app.use '/static/', express.static(config.server.static_root)
  app.use '/static/', (req, res, next) ->
    # We're requesting a non-existent static resource.
    res.send 404

  app.use app.router

  app.set 'views', config.server.views_root
  app.set 'view engine', 'jade'

  # HttpError error handling middleware.
  app.use (err, req, res, next) ->
    if err.statusCode
      res.send err.statusCode, err
    else
      next err


# Set the development environment.
app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  process.env.LOG_LEVEL = 'debug'

# Set the development environment.
app.configure 'staging', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  process.env.LOG_LEVEL = 'debug'

# Set the production environment too.
app.configure 'production', ->
  app.use express.errorHandler()
  process.env.LOG_LEVEL = 'error'


# Start me up! (If you start me up, I'll never stop.)
app.listen app.get('port'), ->
  log.debug "Express server listening on port #{app.get('port')} "
  + "in #{app.settings.env} mode"


app.use '/api', require('./poet')

app.get '/', require('./routes').setup(app)


app.use (req, res) ->
  console.log('default route', req.path)
  res.sendfile path.join(config.server.static_root, 'index.html')

