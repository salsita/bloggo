_ = require 'underscore'

exports.setup = (poet) ->

  index: (req, res) ->
    posts = []

    tags = JSON.parse(req.query.tags or '[]')
    category = req.query.category

    if _.isEmpty(tags) and not category
      # No tag or category => load all posts.
      posts = poet.helpers.getPosts()

    if tags.length > 0
      # Get only posts that contain all the requested tags.
      posts = _.reduce _.rest(tags), (list, tag) ->
        _.intersection list, poet.helpers.postsWithTag tag
      , poet.helpers.postsWithTag(tags[0])

    if category
      if tags.length == 0
        # Just the category filter, no tags.
        posts = poet.helpers.postsWithCategory category
      else
        # User wants both tags and category. Get the matching posts.
        posts = _.filter posts, (post) -> post.category == category

    if req.query.year
      # Filtering by year.
      posts = _.filter posts, (post) ->
        return post.date.getFullYear() == parseInt(req.query.year)

    if req.query.month
      # Filtering by month (and possibly a year).
      posts = _.filter posts, (post) ->
        return post.date.getMonth() == parseInt(req.query.month)

    # Get posts grouped by their year.
    postsByYear = _.groupBy posts, (post) ->
      post.date.getFullYear()

    # Get post counts grouped by their year and month (e.g. 2012: 2: 42,
    # meaning there are 42 posts from January 2012).
    postCountByYearAndMonth = _.reduce postsByYear, (obj, posts, year) ->
      obj[year] = _.countBy posts, (post) ->
        post.date.getMonth()
      return obj
    , {}

    # Collect all tags in the result set.
    filteredTags = _.union.apply null, _.pluck posts, 'tags'
    # Collect all categories in the result set (filter out `null` values).
    filteredCategories = _.filter _.pluck(posts, 'category'), (c) -> !! c

    # Paging.
    from = parseInt(req.query.from or null)
    to = null
    if _.isNumber(from) and req.query.limit
      to = from + parseInt(req.query.limit)
    slicedPosts = posts.slice from, to

    # Send the data to the client.
    res.json
      data:
        meta:
          total: posts.length
          stats: postCountByYearAndMonth
          tags: filteredTags
          categories: filteredCategories
        data: slicedPosts


  show: (req, res) ->
    post = poet.helpers.getPost req.params.post
    if post
      res.json post
    else
      res.send 404, "Post #{req.params.post} not found."
