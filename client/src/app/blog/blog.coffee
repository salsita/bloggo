angular.module('salsitasoft.blog', [
  'ui.state'
  'ngResource'
  'infinite-scroll'
])

.config ($stateProvider) ->
  $stateProvider.state "postList",
    url: "/posts"
    views:
      main:
        controller: "BlogCtrl"
        templateUrl: 'blog/blog.html'

  $stateProvider.state "postDetail",
    url: "/post/:postId"
    views:
      main:
        controller: "PostCtrl"
        templateUrl: 'blog/post.html'


.factory 'Blog', ($resource) ->
  return $resource "/api/posts/:id", {
    id: '@id'
  }, {
    query:
      method: 'GET'
      isArray: no
  }


.controller 'BlogCtrl', ($scope, $state, Blog, Restangular) ->

  limit = 5

  posts = Restangular.all 'posts'

  $scope.posts = []
  $scope.metadata = {}
  $scope.busy = false
  $scope.selectedTags = []

  $scope.loadMorePosts = ->
    if $scope.metadata.total
      if $scope.posts.length >= $scope.metadata.total - limit
        return

    $scope.busy = true
    tags = if $scope.selectedTags.length then [$scope.selectedTags] else ''
    qPosts = posts.getList {
      from: $scope.posts.length, limit: limit, tags: tags
    }
    qPosts.then (data) ->
      $scope.posts = $scope.posts.concat data
      $scope.metadata = data.metadata
      $scope.busy = false

  $scope.postSelected = (slug) ->
    $state.transitionTo 'postDetail', {postId: slug}

  $scope.tagSelected = (tag) ->
    $scope.selectedTags = [tag]
    $scope.posts = []
    $scope.metadata = {}
    $scope.loadMorePosts()


.controller 'PostCtrl', ($scope, Blog, $stateParams, $state, Restangular) ->

  post = Restangular.one 'posts', $stateParams.postId

  $scope.data = post.get()

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

.directive 'postList', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    timeout = null

    $(document).on 'scroll.blog', ->
      timeout = timeout or window.setTimeout ->
        $(element).find('.post').each ->
          borders =
            top: $(this).offset().top - $(document).scrollTop()
            bottom: $(this).offset().top + $(this).outerHeight() -
              $(document).scrollTop()
          center = $(window).height() / 2
          if borders.top < center and borders.bottom > center
            $(this).addClass 'active'
            console.log 'active'
          else
            $(this).removeClass 'active'
        timeout = null
      , 200

    scope.$on '$destroy', ->
      console.log 'destroying post list scope'
      $(document).off 'scroll.blog'


.filter 'monthIndexToString', ($filter) ->
  (input) ->
    d = new Date()
    d.setMonth input
    $filter('date')(d, 'MMMM')
