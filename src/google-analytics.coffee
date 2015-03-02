# Description
#   A hubot script that queries Google Analytics Data
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   pageviews list - list all Google Analytics profiles accessible.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Mostafa Zaher[@<org>]

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
