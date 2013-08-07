angular.module('salsitasoft.blog', [
  'ui.state'
  'ngResource'
  'infinite-scroll'
  'ngDisqus'
])

.config ($stateProvider) ->
  $stateProvider.state "blog",
    # The blog main page.
    url: "/posts"
    views:
      main:
        controller: "BlogCtrl"
        templateUrl: 'blog/blog.html'

  $stateProvider.state "postDetail",
    # Blog post detail.
    url: "/post/:postId"
    views:
      main:
        controller: "PostCtrl"
        templateUrl: 'blog/post.html'


.controller 'BlogCtrl', ($scope, $state, Restangular) ->

  limit = 5

  # Create resource endpoints.
  posts = Restangular.all 'posts'
  categories = Restangular.all 'categories'
  #tags = Restangular.all 'tags'

  # Set up the model.
  $scope.posts = []
  $scope.metadata = {}
  $scope.busy = false
  $scope.categories = categories.getList()
  $scope.activePost = null
  #$scope.tags = tags.getList()

  # Throw away the old posts and load new ones.
  resetPosts = ->
    $scope.posts = []
    $scope.metadata = []
    $scope.loadMorePosts()

  # Filter by year/month.
  $scope.filterDate = (year = null, month = null) ->
    $scope.filter.year = year
    $scope.filter.month = month
    resetPosts()

  $scope.orderByMonth = (month) ->
    console.log month
    parseInt(month)

  # Get data from the server.
  $scope.loadMorePosts = ->
    # Check if there's any posts left.
    if $scope.metadata.total
      if $scope.posts.length >= $scope.metadata.total
        return

    $scope.busy = true

    qPosts = posts.getList {
      from: $scope.posts.length
      limit: limit
      year: $scope.filter.year
      month: $scope.filter.month
      tags: JSON.stringify($scope.filter.tags)
      category: $scope.filter.category
    }
    qPosts.then (data) ->
      $scope.posts = $scope.posts.concat data
      $scope.metadata = data.metadata
      $scope.busy = false

  $scope.postSelected = (slug) ->
    $state.transitionTo 'postDetail', {postId: slug}

  $scope.postActivated = (post) ->
    post.date = new Date(post.date)
    $scope.activePost = post
    console.log 'active post', post

  $scope.tagSelected = (tag) ->
    $scope.filter.tags.push tag unless tag in $scope.filter.tags
    resetPosts()

  $scope.categorySelected = (category) ->
    $scope.filter.category = category
    resetPosts()

  $scope.resetFilters = ->
    $scope.filter =
      tags: []
      category: null
      year: null
      month: null
    resetPosts()

  # Set filters to stun...uh, sorry, to empty sate.
  $scope.resetFilters()


.controller 'PostCtrl', ($scope, $stateParams, $state, Restangular, $disqus) ->
  post = Restangular.one 'posts', $stateParams.postId

  # Required by Disqus.
  $disqus.shortname('salsita')

  $scope.data = post.get()

  $scope.showAll = ->
    $state.transitionTo 'blog'


# Ensure the `read more` link rendered by the server in the post preview
# actually does something (i.e. call function specified by `read-more`).
#
# Example:
#
#    <div class="preview"
#         blog-post-preview="post.preview"
#         read-more="postSelected(post.slug)">
#
.directive 'blogPostPreview', ($compile, $parse) ->
  restrict: 'EA'
  link: (scope, element, attrs) ->
    previewHTML = $parse(attrs.blogPostPreview)(scope)
    $(element).append $compile(previewHTML)(scope)

    # Notify parent controller when user clicks the 'read more' link.
    $(element).find('a.read-more').on 'click', ->
      scope.$apply ->
        $parse(attrs.readMore)(scope)


# Adds `active` class to the element in the vertical center of the viewport.
.directive 'markCenterElement', ->

  # add `markClass` CSS class to the element in viewport center.
  markCentralElement = (element, itemSelector, markClass="active") ->
    $(element).find(itemSelector).each ->
      borders =
        top: $(this).offset().top - $(document).scrollTop()
        bottom: $(this).offset().top + $(this).outerHeight() -
          $(document).scrollTop()
      if borders.top <= ($(window).height() / 2) <= borders.bottom
        $(this).addClass markClass
      else
        $(this).removeClass markClass

  restrict: 'A'
  link: (scope, element, attrs) ->
    timeout = null

    # Change the marked element as the user scrolls (we're using timeout to go
    # easy on the CPU).
    $(document).on 'scroll.blog', ->
      timeout = timeout or window.setTimeout ->
        timeout = null
        scope.$apply ->
          markCentralElement(
            element, attrs.itemSelector, attrs.markCenterElement
          )
      , 200

    scope.$watch (-> $(element).find(attrs.itemSelector).length), (len) ->
      if len > 0
        # Make sure central element is marked even if the user
        # didn't scroll yet.
        markCentralElement element, attrs.itemSelector, attrs.markCenterElement

    # Clean up.
    scope.$on '$destroy', -> $(document).off 'scroll.blog'


.directive 'watchClass', ($parse) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    scope.$watch ->
      $(element).hasClass attrs.watchClass
    , (hasClass) ->
      if hasClass
        $parse(attrs.onClassAdded)(scope)


# Converts month with 0-based index to its string value, e.g. 2 -> "February".
.filter 'monthIndexToString', ($filter) ->
  (input) ->
    d = new Date()
    d.setMonth input
    $filter('date')(d, 'MMMM')
