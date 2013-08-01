exports.setup = (poet) ->

  index: (req, res) ->
    posts = poet.helpers.getPosts()
    res.json posts

  show: (req, res) ->
    post = poet.helpers.getPost req.params.post
    if post
      res.json post
    else
      res.send 404, "Post #{req.params.post} not found."
