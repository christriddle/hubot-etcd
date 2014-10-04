# Description:
#   A Hubot script for querying an Etcd cluster
#
# Dependencies:
#   None
#
# Commands:
#   hubot etcd <alias> cluster health - show cluster health
#   hubot etcd <alias> get <key> - gets the value of a key
#   hubot etcd add alias <alias> <etcd_host> <etcd_port> - add an alias to a Etcd cluster
#   hubot etcd remove alias <alias> - removes an alias
#   hubot etcd list aliases - lists all etcd aliases
#
# Author:
#   Chris Riddle

_ = require "underscore"

module.exports = (robot) ->

  urlTemplate = "http://%s:%s/"
  aliases = {}

  getUrl = (alias, rest) ->
    data = aliases[alias]
    if !data?
      return
    host = data.host
    port = data.port
    return "http://" + host + ":" + port + rest

  robot.brain.on 'loaded', () ->
    aliases = robot.brain.data.etcdAliases || {}

  robot.respond /etcd (\S+) cluster health$/i, (msg) ->
    alias = msg.match[1]

    url = getUrl alias "/stats/self" # ?
    if !url?
      msg.send "No such alias: " + alias
      return

    msg.http(url).get() (err, res, body) ->
      if err?
        msg.send "Error getting cluster health: " + err
        return

      bodyJson = JSON.parse(body)

      if bodyJson.errorCode?
        # todo
        return
      msg.send "Cluster health comming soon to a robot near you"

  robot.respond /etcd (\S+) get (\S+)$/i, (msg) ->
    key = msg.match[2]
    alias = msg.match[1]

    keyPath = "/v2/keys/" + key
    url = getUrl alias, keyPath

    if !url?
      msg.send "No such alias: " + alias
      return

    msg.http(url).get() (err, res, body) ->
      if err?
        msg.send "Error getting key [" + key + "]: " + err
        return

      msg.send "/code #{body}"

  robot.respond /etcd add alias (\S+) (\S+) (\S+)$/i, (msg) ->
    alias = msg.match[1]
    host = msg.match[2]
    port = msg.match[3]

    aliases[alias] = { host: host, port: port }
    robot.brain.data.etcdAliases = aliases
    msg.send "Alias added"

  robot.respond /etcd remove alias (\S+)$/i, (msg) ->
    alias = msg.match[1]

    delete aliases[alias]
    robot.brain.data.etcdAliases = aliases
    msg.send "Alias removed"

  robot.respond /etcd (list|show) aliases/i, (msg) ->
    pretty = JSON.stringify aliases
    msg.send "/code #{pretty}"
