require 'sinatra'
require "json"
require 'httparty'
require_relative 'awyisser'

get '/awyiss' do
  return status 401 unless verified_token(params[:token])
  post_message(params)

  startup_message
end

def verified_token(token)
  token = ENV['SLACK_COMMAND_TOKEN']
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
  # return maintenance_message # uncomment to put bot in maintenance
  case text.strip
    when /^sfw\s(\S.+)/
      Awyisser.image_url($1, true)
    when /^(\S.+)/
      Awyisser.image_url($1, false)
    else
      Awyisser.image_url("wut?", true)
  end
end

def maintenance_message
  "aw nooo... maintenance until further notice ( ᵒ̴̶̷̥́ _ᵒ̴̶̷̣̥̀ )"
end

def startup_message
  content_type :json
  {
    "response_type": "ephemeral",
    "text": "Hold on, the awyiss bot is waking up..."
  }.to_json
end
