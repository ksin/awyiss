require "slack-ruby-client"
require "net/http"
require "uri"
require "json"

puts "WARNING!!! awyisser tweets all your yisses to @awyisser, so maybe don't put anything you don't want tweeted?"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

module AwYisser
  URL = "http://ink1001.com/p/lp/116570e1643601f3.png"

  def awyissify(phrase)
    if phrase.length > 40
      return "aw nooo... your phrase is too long! (40 chars max)"
    end
    if sfw
      return "aw yiss motha flippin #{phrase} #{get_image(phrase)}"
    end
    "aw yiss motha fuckin #{phrase} #{get_image(phrase)}"
  end

  def get_image(phrase)
    params = {"phrase" => phrase}
    params["sfw"] = true if sfw # required to only add sfw key conditionally because {"sfw" => false} still registers as true
    response = httpPostRequest(URL, params)
    JSON.parse(response.body)["link"]
  end

  def httpPostRequest(url, data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)
    http.request(request)
  end
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
        when /^awyiss\ssfw\s(\S.+)/
          @sfw = true
          awyissify($1)
        when /^awyiss\s(\S.+)/
          @sfw = false
          awyissify($1)
        else
          "wut?"
      end
    end

    def maintenance_message
      "aw nooo... maintenance until further notice ( ᵒ̴̶̷̥́ _ᵒ̴̶̷̣̥̀ )"
    end
  end
end
