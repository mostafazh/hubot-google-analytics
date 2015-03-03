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
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mostafazh/hubot-google-analytics/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

