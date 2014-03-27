config = require 'config'
path = require 'path'

exports.setup = (app) ->

  app.get '/', (req, res) ->
    res.sendfile path.join(config.server.static_root, 'index.html')
