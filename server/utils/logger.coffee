winston = require 'winston'

logConfig =
  levels:
    silly: 0
    trace: 1
    debug: 2
    info: 3
    notice: 4
    warning: 5
    error: 6
    crit: 7
    alert: 8
    emerg: 9

  colors:
    silly: "magenta"
    trace: "grey"
    debug: "blue"
    info: "green"
    notice: "yellow"
    warning: "orange"
    error: "red"
    crit: "red"
    alert: "yellow"
    emerg: "red"

winston.addColors logConfig.colors

logger = new winston.Logger
  levels: logConfig.levels
  transports: [
    new winston.transports.Console(
      level: process.env.LOG_LEVEL or 'error',
      colorize: 'true'
    ),
  ]


exports.log = logger
