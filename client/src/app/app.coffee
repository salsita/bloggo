angular.module("salsitasoft", [
  "templates-app"
  "templates-common"
  "templates-jade_app"
  "templates-jade_common"

  "salsitasoft.blog"
  "titleService"

  "ui.router"

  "ngSanitize"
  "restangular"
])
  

.config ($urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise "/posts"
  $locationProvider.html5Mode(true).hashPrefix "#"
  

.config (RestangularProvider) ->
  RestangularProvider.setResponseExtractor (response, operation) ->
    newResponse = null

    if operation is "getList"
      # Here we're returning an Array which has one special
      # property metadata with our extra information
      newResponse = response.data.data
      newResponse.metadata = response.data.meta
    else
      # This is an element
      newResponse = response
    return newResponse

  RestangularProvider.setBaseUrl "/api"


.run (titleService, $rootScope) ->
  titleService.setSuffix " | salsitasoft"
  $rootScope.$on "$routeChangeSuccess", (newRoute, oldRoute) ->
    console.log "scroll to", $routeParams.scrollTo
    $location.hash $routeParams.scrollTo
    $anchorScroll()

  $rootScope.$on "$routeChangeStart", (newRoute, oldRoute) ->
    console.log "scroll to", $routeParams.scrollTo

    
.controller "AppCtrl", ($scope, $location, $state) ->
  # nada

