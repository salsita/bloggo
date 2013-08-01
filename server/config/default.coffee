# Default configuration
# =====================
#
# Can be overriden for developers needs (just create a `development.coffee`
# file with your settings in this directory.
#
# Will be overriden by config files generated on chef deployment (
# `staging.coffee` and `production.coffee`).

path = require 'path'

module.exports =
  server:
    static_root: path.join __dirname, '../../client/build'
    views_root: path.join __dirname, '../views'
