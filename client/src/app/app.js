angular.module( 'salsitasoft', [
  'templates-app',
  'templates-common',

  'templates-jade_app',
  'templates-jade_common',

  'ngBoilerplate.home',
  'ngBoilerplate.about',

  'salsitasoft.blog',
  'ui.state',
  'ui.route',
  'ngSanitize',

  'restangular'
])

.config( function ($urlRouterProvider, $locationProvider) {
  $urlRouterProvider.otherwise('/posts');
  $locationProvider.html5Mode(true).hashPrefix('#');
})

.config( function (RestangularProvider) {

    // Now let's configure the response extractor for each request
    RestangularProvider.setResponseExtractor(function(response, operation, what, url) {
      // This is a get for a list
      var newResponse;
      if (operation === "getList") {
        // Here we're returning an Array which has one special property metadata with our extra information
        newResponse = response.data.data;
        newResponse.metadata = response.data.meta;
      } else {
        // This is an element
        newResponse = response;
      }
      return newResponse;
    });

    RestangularProvider.setBaseUrl("/api");
})

.run( function ( titleService, $rootScope ) {
  titleService.setSuffix( ' | salsitasoft' );

  $rootScope.$on('$routeChangeSuccess', function(newRoute, oldRoute) {
    console.log('scroll to', $routeParams.scrollTo);
    $location.hash($routeParams.scrollTo);
    $anchorScroll();
  });

  $rootScope.$on('$routeChangeStart', function(newRoute, oldRoute) {
    console.log('scroll to', $routeParams.scrollTo);
  });
})

.controller( 'AppCtrl', function AppCtrl ( $scope, $location, $state ) {
})

;

