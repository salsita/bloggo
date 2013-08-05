_ = require 'underscore'

exports.setup = (poet) ->

  index: (req, res) ->
    if req.query.tags
      tags = JSON.parse req.query.tags
      return res.json _.reduce tags, (list, tag) ->
        _.union list, poet.helpers.postsWithTag tag
      , []

    res.json poet.helpers.getPosts()

  show: (req, res) ->
    post = poet.helpers.getPost req.params.post
    if post
      res.json post
    else
      res.send 404, "Post #{req.params.post} not found."
