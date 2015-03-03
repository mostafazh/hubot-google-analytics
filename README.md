# hubot-google-analytics

A hubot script that queries Google Analytics Data

See [`src/google-analytics.coffee`](src/google-analytics.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-google-analytics --save`

Then add **hubot-google-analytics** to your `external-scripts.json`:

```json
["hubot-google-analytics"]
```

## Sample Interaction

```
user1>> pageviews list
hubot>> Profle 1 - http://www.example.com - 12345678
Profle 2 - http://test.example.com - 12345679
user1>> @hubot pageviews 12345678 yesterday
hubot>> From: 2015-03-03 To: 2015-03-03
1,234 visits and 2,345 pageviews.
user1>> @hubot pageviews 12345678 this year
hubot>> From: 2015-01-01 To: 2015-03-04
9,012 visits and 10,123 pageviews.
```
