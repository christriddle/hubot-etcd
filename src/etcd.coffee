# Description:
#   A Hubot script for querying an Etcd cluster
#
# Dependencies:
#   None
#
# Commands:
#   hubot etcd cluster health <alias> - show cluster health
#   hubot etcd get <key> for <alias> - gets the value of a key
#   hubot etcd add alias <alias> <etcd_host> <etcd_port> - add an alias to a Etcd cluster
#   hubot etcd remove alias <alias> - removes an alias
#   hubot etcd list aliases - lists all etcd aliases
#
# Author:
#   Chris Riddle

_ = require "underscore"

module.exports = (robot) ->

  urlTemplate = "http://%s:%s/"

  getUrl = (alias, rest) ->
    host = alias.host # todo
    port = alias.port # todo
    return "http://" + host + ":" + port + rest

  robot.respond /etcd cluster health (\S+)$/i, (msg) ->
    alias = msg.match[1]
    url = getUrl alias "/stats/self" # ?
    # handle alias not found

    msg.http(url).get() (err, res, body) ->
      if err?
        msg.send "Error getting cluster health: " + err
        return

      bodyJson = JSON.parse(body)

      if bodyJson.errorCode?
        # todo
        return

      msg.send "Health:"

  robot.respond /etcd get (\S+) for (\S+)$/i, (msg) ->
    key = msg.match[1]
    alias = msg.match[2]

    url = getUrl alias key

    msg.http(url).get() (err, res, body) ->
      if err?
        msg.send "Error getting key [" + key + "]: " + err
        return

      msg.send "Value!"

  robot.respond /etcd add alias (\S+) (\S+) (\S+)$/i, (msg) ->
    alias = msg.match[1]
    host = msg.match[2]
    port = msg.match[3]

  robot.respond /etcd remove alias (\S+)$/i, (msg) ->
    alias = msg.match[1]

  robot.respond /etcd list aliases$/i, (msg) ->
