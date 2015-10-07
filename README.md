# Slack bot awyisser

![awyiss](screencapture.gif)

A simple way to run your own Slack bot for generating awyiss images via the awesome [awyisser](http://www.awyisser.com/).

## Installation

1. [Create a new bot user](https://my.slack.com/services/new/bot) integration for your Slack group.

2. Deploy this Sinatra app to [Heroku](https://devcenter.heroku.com/articles/rack#sinatra) or whatever service you prefer.

3. Setup a new [outgoing webhook](https://my.slack.com/services/new/outgoing-webhook) for your Slack group.

    - Set the Trigger Word as "awyiss" (and any other words you want)

    - Set the URL as the one you deployed your app to + `/awyiss`. For Heroku, it will look something like `https://floating-thunder-7193.herokuapp.com/awyiss`

4. Export your Slack bot's token (NOT your webhook token) as `SLACK_API_TOKEN` to Heroku / other environment.

## How to awyiss

```
awyiss something awsome happened.
awyiss motha fuckin very awsome happed.
```

## Playing it safe (sfw aw yissing)

```
awyiss sfw hoi!!
awyiss sfw hoi! im temmie!!!
```

***WARNING!!!*** awyisser tweets all your yisses to [@awyisser](https://twitter.com/awyisser), so maybe don't put anything you don't want tweeted?

## Credits

Thanks to the wonderful [Kate Beaton](http://harkavagrant.com/) for writing the comic and [@quinnkeast](https://twitter.com/quinnkeast) for making the original awyisser. The bot is inspired by [hubot-awyisser](https://github.com/emilong/hubot-awyisser). Contributors to this project includes: [Ken Sin](https://github.com/ksin) and [Movable Ink](https://github.com/movableink).
