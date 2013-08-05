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

  return {
    getPosts: -> posts
    getPost: (postId) -> _.findWhere posts, slug: postId
    getPostsForTag: (tag) -> postsRes.query tags: JSON.stringify [tag]
  }


.controller 'BlogCtrl', ($scope, $state, Blog) ->
  $scope.posts = Blog.getPosts()

  $scope.postSelected = (slug) ->
    $state.transitionTo 'postDetail', {postId: slug}

  $scope.tagSelected = (tag) ->
    $scope.posts = Blog.getPostsForTag tag


.controller 'PostCtrl', ($scope, Blog, $stateParams, $state) ->
  $scope.data = $scope.$watch ->
    Blog.getPost($stateParams.postId)
  , (newVal) ->
    $scope.data = newVal
  , true

  $scope.showAll = ->
    $state.transitionTo 'postList'


.directive 'blogPostPreview', ($compile, $parse) ->
  restrict: 'EA'
  link: (scope, element, attrs) ->
    previewHTML = $parse(attrs.previewContent)(scope)
    $(element).append $compile(previewHTML)(scope)

    # Notify parent controller when user clicks the 'read more' link.
    $(element).find('a.read-more').on 'click', ->
      scope.$apply ->
        $parse(attrs.onReadMoreClicked)(scope)
