Poet = require 'poet'
path = require 'path'

exports.setup = (app) ->
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

  app.resource 'api/posts', require('./routes/posts').setup poet
