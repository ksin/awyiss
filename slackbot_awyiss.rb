require "slack-ruby-client"
require_relative "awyisser"

puts "WARNING!!! awyisser may tweet your yisses to @awyisser, so maybe don't put anything you don't want tweeted?"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

class SlackBot
  class AwYiss
    include AwYisser

    attr_reader :sfw, :text

    def initialize(channel, text)
      @channel = channel
      @text = text
      @sfw = false
      @client = Slack::Web::Client.new
    end

    def post_to_slack
      @client.chat_postMessage(channel: @channel, text: message, as_user: true)
    end

    def message
      # return maintenance_message
      case text.strip
        when /^(awyiss||aw\syiss||aww\syiss)\ssfw\s(\S.+)/
          @sfw = true
          awyissify($2)
        when /^(awyiss||aw\syiss||aww\syiss)\s(\S.+)/
          @sfw = false
          awyissify($2)
        else
          "wut?"
      end
    end

    def maintenance_message
      "aw nooo... maintenance until further notice ( ᵒ̴̶̷̥́ _ᵒ̴̶̷̣̥̀ )"
    end
  end
end
