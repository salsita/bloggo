express = require 'express'
Poet = require 'poet'
path = require 'path'

module.exports = app = express()


poet = Poet app,
  posts: path.join __dirname, '../_posts'
  metaFormat: 'yaml'
  routes: {posts: null}
  readMoreLink: (post) -> """
    <a class="read-more" ng-click="foo" title='Read more of #{post.title}'>
      Read More
    </a>
    """
poet.addTemplate
  ext: 'html',
  fn : (s) -> s

poet.watch ->
  console.log 'Poet watcher!'
.init()

app.resource 'posts', require('./routes/posts').setup poet

app.resource 'tags', {
  index: (req, res) ->
    res.json poet.helpers.getTags()
}

app.resource 'categories', {
  index: (req, res) ->
    res.json poet.helpers.getCategories()
}
