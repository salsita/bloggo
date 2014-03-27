{spawn, exec} = require 'child_process'
{print}       = require 'util'
fs            = require 'fs'
path          = require 'path'
glob          = require 'glob'
_             = require 'underscore'


MOCHA_PATH = "node_modules/.bin/mocha"

exports.pathDelimiter = if process.platform is 'win32' then ';' else ':'

exports.stream = (command, options, callback) ->
  sub = spawn command, options
  sub.stdout.on 'data', (data) -> print data.toString()
  sub.stderr.on 'data', (data) -> print data.toString()
  sub.on 'exit', (status) -> callback?(status)
  sub

exec_std = (cmd) ->
  exec cmd,
    (err, stdout, stderr) ->
      print stdout if stdout?
      print stderr if stderr?

# Iterates over given directory and its subdirectories. Returns an array of
# files that match `pattern` && do not match any pattern defined in
# `exclude_patterns`.
exports.getFiles = (pattern, exclude_patterns=[]) ->
  result = _.difference(
    glob.sync pattern, (glob.sync pat for pat in exclude_patterns)
  )
  result or []
