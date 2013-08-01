{spawn, exec} = require 'child_process'
{print}       = require 'util'
fs            = require 'fs'
path          = require 'path'
glob          = require 'glob'
_             = require 'underscore'
eco           = require 'eco'


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

# Compiles all .coffee files found in `path`.
exports.compileFiles = (sourceDir, outputDir, callback) ->
  exports.stream 'coffee', ['-c', '-o', outputDir, sourceDir], -> callback?()

# Preprocesses all `.eco` templates found in `dir`.
exports.preprocessFiles = (dir, opts) ->
  # Preprocess front end files
  # Find all .eco files for preprocessing
  files = exports.getFiles "#{dir}/**/*.eco", ['**/node_modules/**']
  for filename in files
    fileContent = fs.readFileSync filename, 'utf8'
    outputFile = filename.replace /.eco$/,''
    expandedContent = eco.render fileContent, opts, 'utf8'
    fs.writeFileSync outputFile, expandedContent
