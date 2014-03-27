express = require 'express'
config = require 'config'
Poet = require 'poet'
path = require 'path'

module.exports = app = express()

# Configure Poet.
poet = Poet app,
  posts: config.server.posts_root
  metaFormat: 'yaml'
  # Set up the how the 'read more' link in posts will be expanded.
  readMoreLink: (post) -> """
    <a class="read-more" title='Read more of #{post.title}'>
      Read More
    </a>
    """

poet
  # Add support for vanilla HTML blag posts (e.g. for WordPress imports).
  .addTemplate
    ext: 'html',
    fn : (s) -> s
  # Watch the posts dir for changes.
  .watch(->)
  .init()


# Routes
# ------

app.resource 'posts', require('./routes/posts').setup poet

app.resource 'tags',
  index: (req, res) ->
    res.json
      data:
        data: poet.helpers.getTags()
        meta: {}

app.resource 'categories',
  index: (req, res) ->
    res.json
      data:
        data: poet.helpers.getCategories()
        meta: {}
