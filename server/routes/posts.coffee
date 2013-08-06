_ = require 'underscore'

exports.setup = (poet) ->

  index: (req, res) ->
    posts = []

    if req.query.tags
      tags = JSON.parse req.query.tags
      # Get all the posts that have any of the specified tags.
      posts = _.reduce tags, (list, tag) ->
        _.union list, poet.helpers.postsWithTag tag
      , []
    else
      posts = poet.helpers.getPosts()

    postsByYear = _.groupBy posts, (post) ->
      post.date.getFullYear()

    postsByYearByMonths = _.reduce postsByYear, (obj, posts, year) ->
      obj[year] = _.countBy posts, (post) ->
        post.date.getMonth()
      return obj
    , {}

    from = parseInt(req.query.from or null)
    to = null
    if _.isNumber(from) and req.query.limit
      to = from + parseInt(req.query.limit)
    slicedPosts = posts.slice from, to

    res.json
      data:
        meta:
          total: posts.length
          stats: postsByYearByMonths
        data: slicedPosts


  show: (req, res) ->
    post = poet.helpers.getPost req.params.post
    if post
      res.json post
    else
      res.send 404, "Post #{req.params.post} not found."
