require 'sinatra'
require "json"
require 'httparty'
require_relative 'awyisser'

get '/awyiss' do
  return status 401 unless verified_token(params[:token])
  post_message(params)

  status 200
end

def verified_token(token)
  token == ENV['SLACK_COMMAND_TOKEN']
end

def post_message(params)
  image = awyissify(params[:text])
  HTTParty.post params[:response_url],
                body: { "response_type" => "in_channel",
                        "attachments" => [
                          "image_url": image
                        ],
                        "channel" => params[:channel_id]}.to_json,
                headers: {'content-type' => 'application/json'}
end

def awyissify(text)
  case text.strip
    when /^sfw\s(\S.+)/
      Awyisser.image_url($1, true)
    when /^(\S.+)/
      Awyisser.image_url($1, false)
    else
      Awyisser.image_url("wut?", true)
  end
end
