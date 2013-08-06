express = require 'express'
Poet = require 'poet'
path = require 'path'


module.exports = app = express()


POSTS_DIR = path.join __dirname, '../_posts'


# Configure Poet.
poet = Poet app,
  posts: POSTS_DIR
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

app.resource 'tags', {
  index: (req, res) ->
    res.json poet.helpers.getTags()
}

app.resource 'categories', {
  index: (req, res) ->
    res.json poet.helpers.getCategories()
}
