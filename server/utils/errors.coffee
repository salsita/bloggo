# This error class is used to relay HTTP errors. The default error middleware
# recognizes the `statusCode` attribute and sends the HTTP response code.
class HttpError extends Error
  constructor: (@message = "", @statusCode = 500) ->
    super
    @name = 'HttpError'
    Error.captureStackTrace this, HttpError


module.exports = {
  HttpError: HttpError
}
