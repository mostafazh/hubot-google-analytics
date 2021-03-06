# Description
#   A hubot script that queries Google Analytics Data
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   pageviews list - list all Google Analytics profiles accessible.
#   analytics profiles list - list "id - name" from all Google Analytics profiles accessible.
#   analytics 12345678 device yesterday - print yesterday's mobile x desktop sessions.
#   analytics 12345678 device last month - print last month's mobile x desktop sessions.
#   pageviews 12345678 yesterday - print yesterday's visits and pageviews.
#   pageviews 12345678 last week - print last week's visits and pageviews.
#   pageviews 12345678 last month - print last month's visits and pageviews.
#   pageviews 12345678 last year - print last year's visits and pageviews.
#   pageviews 12345678 this month - print this month's visits and pageviews.
#   pageviews 12345678 this year - print this year's visits and pageviews.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Mostafa Zaher[me@mostafazh.me]
require('date-utils')
common = require('./lib/common')

format = (x) ->
    return if isNaN(x) then "" else x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")


module.exports = (robot) ->
    robot.hear /pageviews list/i, (msg) ->
        robot.emit "googleapi:request",
          service: "analytics"
          version: "v3"
          endpoint: "management.profiles.list"
          params:                               # parameters to pass to API
            accountId: '~all'
            webPropertyId: '~all'
          callback: (err, data)->               # node-style callback
            return msg.send(err) if err
            msg.send data.items.map((item)->
              "#{item.name} - #{item.websiteUrl} - #{item.id}"
            ).join("\n")

    robot.hear /analytics profiles list/i, (msg) ->
        robot.emit "googleapi:request",
          service: "analytics"
          version: "v3"
          endpoint: "management.profiles.list"
          params:                               # parameters to pass to API
            accountId: '~all'
            webPropertyId: '~all'
          callback: (err, data)->               # node-style callback
            return msg.send(err) if err
            msg.send data.items.map((item)->
              "#{item.id} - #{item.name}"
            ).join("\n")

    robot.respond /analytics\s+(\d+)\s+device\s+(\w+)\s*(\w*)/i, (msg) ->
        websiteId = msg.match[1]
        word1 = msg.match[2].toLowerCase()
        word2 = msg.match[3].toLowerCase()

        command = if word2 then "#{word1}#{word2}" else word1
        startDate = common.get_start_date(command)
        endDate = common.get_end_date(command)

        robot.emit "googleapi:request",
          service: "analytics"
          version: "v3"
          endpoint: "data.ga.get"
          params:                               # parameters to pass to API
            ids: "ga:#{websiteId}"
            metrics: 'ga:sessions'
            dimensions: 'ga:deviceCategory'
            'start-date': startDate
            'end-date': endDate
          callback: (err, data)->               # node-style callback
            msg.send err if err
            total = parseInt(data.totalsForAllResults['ga:sessions'])
            msg.send data.rows.map((item)->
              percentage = (parseInt(item[1])/total)*100
              "#{item[0]} - #{item[1]} sessions (#{percentage.toFixed(2)}%)"
            ).join("\n")

    robot.respond /pageviews\s+(\d+)\s+(\w+)\s*(\w*)/i, (msg) ->
        websiteId = msg.match[1]
        word1 = msg.match[2].toLowerCase()
        word2 = msg.match[3].toLowerCase()

        command = if word2 then "#{word1}#{word2}" else word1
        startDate = common.get_start_date(command)
        endDate = common.get_end_date(command)

        console.log "s: #{startDate}, e: #{endDate}"
        robot.emit "googleapi:request",
          service: "analytics"
          version: "v3"
          endpoint: "data.ga.get"
          params:                               # parameters to pass to API
            ids: "ga:#{websiteId}"
            metrics: 'ga:visits, ga:pageviews'
            'start-date': startDate
            'end-date': endDate
          callback: (err, data)->               # node-style callback
            msg.send err if err
            console.log err
            console.log JSON.stringify(data)
            visits = format(data.totalsForAllResults['ga:visits'])
            pageviews = format(data.totalsForAllResults['ga:pageviews'])
            msg.reply "From: #{startDate} To: #{endDate}\n #{visits} visits and #{pageviews} pageviews."
