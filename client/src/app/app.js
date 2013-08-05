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
  'ngSanitize'
])

.config( function ($urlRouterProvider, $locationProvider) {
  $urlRouterProvider.otherwise('/posts');
  $locationProvider.html5Mode(true).hashPrefix('#');
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

