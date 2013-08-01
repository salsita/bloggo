angular.module('salsitasoft.blog', [
  'ui.state'
  'ngResource'
])

.config ($stateProvider) ->
  $stateProvider.state "postList",
    url: "/posts"
    views:
      main:
        controller: "BlogCtrl"
        templateUrl: 'blog/postList.html'

  $stateProvider.state "postDetail",
    url: "/post/:postId"
    views:
      main:
        controller: "PostCtrl"
        templateUrl: 'blog/post.html'


.factory 'Blog', ($resource) ->
  postsRes = $resource "/api/posts/:id", {
    id: '@id'
  }

  posts = postsRes.query()

  {
    getPosts: -> posts
    getPost: (postId) -> _.findWhere posts, slug: postId
  }


.controller 'BlogCtrl', ($scope, $state, Blog) ->
  console.log 'blog ctrl'
  $scope.posts = Blog.getPosts()
  $scope.postSelected = (slug) ->
    console.log 'selected post', slug
    $state.transitionTo 'postDetail', {postId: slug}



.controller 'PostCtrl', ($scope, Blog, $stateParams) ->
  console.log 'post ctrl', $stateParams.postId
  $scope.data = $scope.$watch ->
    Blog.getPost($stateParams.postId)
  , (newVal) ->
    $scope.data = newVal
  , true


.directive 'blogPostPreview', ($compile, $parse) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    unregister = scope.$watch ->
      $(element).find('a.read-more').length

    , (present) ->
      return unless present
      # Notify parent controller when user clicks the 'read more' link.
      $(element).find('a.read-more').on 'click', ->
        scope.$apply ->
          $parse(attrs.readMoreSelected)(scope)

      # Click eent hander is set. We can remove the watcher now.
      unregister()
