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

.config( function myAppConfig ($urlRouterProvider, $locationProvider) {
  $urlRouterProvider.otherwise('/posts');
  $locationProvider.html5Mode(true);
})

.run( function run ( titleService, $rootScope ) {
  titleService.setSuffix( ' | salsitasoft' );

  $rootScope.$on('$routeChangeSuccess', function(newRoute, oldRoute) {
    $location.hash($routeParams.scrollTo);
    $anchorScroll();
  });
})

.controller( 'AppCtrl', function AppCtrl ( $scope, $location, $state ) {
})

;

