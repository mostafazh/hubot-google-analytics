# Description
#   A hubot script that queries Google Analytics Data
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   pageviews list - list all Google Analytics profiles accessible.
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
            return console.log(err) if err
            msg.send data.items.map((item)->
              "#{item.name} - #{item.websiteUrl} - #{item.id}"
            ).join("\n")

    robot.hear /pageviews list compact/i, (msg) ->
        robot.emit "googleapi:request",
          service: "analytics"
          version: "v3"
          endpoint: "management.profiles.list"
          params:                               # parameters to pass to API
            accountId: '~all'
            webPropertyId: '~all'
          callback: (err, data)->               # node-style callback
            return console.log(err) if err
            msg.send data.items.map((item)->
              "#{item.name} - #{item.id}"
            ).join("\n")

    robot.respond /pageviews\s+(\d+)\s+(\w+)\s*(\w*)/i, (msg) ->
        websiteId = msg.match[1]
        word1 = msg.match[2].toLowerCase()
        word2 = msg.match[3].toLowerCase()
        command = if word2 then "#{word1}#{word2}" else word1
        console.log command
        startDate = Date.today()
        endDate = Date.today()
        if command == "lastyear"
            startDate = startDate.removeDays(365)
        else if command == "lastmonth"
            startDate = startDate.removeDays(30)
        else if command == "lastweek"
            startDate = startDate.removeDays(7)
        else if command == "thisyear"
            startDate.setMonth(0)
            startDate.setDate(1)
            endDate.setMonth(11)
            endDate.setDate(1)
        else if command == "thismonth"
            startDate.setDate(1)
        else if command == "yesterday"
            startDate = Date.yesterday()
            endDate = Date.yesterday()
        # else if command == "today"
        else
            return

        startDate = startDate.toYMD("-")
        endDate = endDate.toYMD("-")

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
