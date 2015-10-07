require 'slack-ruby-client'
require "net/http"
require "uri"

puts "WARNING!!! awyisser tweets all your yisses to @awyisser, so maybe don't put anything you don't want tweeted?"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

module AwYisser
  URL = "http://awyisser.com/api/generator"

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
    eval(response.body)[:link]
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

    attr_reader :client, :sfw, :channel

    def initialize
      @sfw = false
      @client = Slack::RealTime::Client.new
      setup_client
    end

    def setup_client
      client.on :message do |data|
        @channel = data['channel']

        case data['text']
        when /^awyiss\ssfw\s(\S.+)/ then
          @sfw = true
          respond_to_slack(awyissify($1))
        when /^awyiss\s(\S.+)/ then
          @sfw = false
          respond_to_slack(awyissify($1))
        when /^awyiss/ then
          respond_to_slack("aw <@#{data['user']}>?")
        end
      end
    end

    def respond_to_slack(message)
      client.web_client.chat_postMessage channel: channel, text: message, as_user: true
    end
  end
end

SlackBot::AwYiss.new.client.start!
