require 'sinatra'
require "json"
require 'httparty'
require_relative 'awyisser'

get '/awyiss' do
  return status 401 unless params[:token] == ENV['SLACK_COMMAND_TOKEN']
  post_message(params)

  status 200
end

def post_message(params)
  image = Awyisser.awyissify(params[:text])
  HTTParty.post params[:response_url],
                body: { "response_type" => "in_channel",
                        "attachments" => [
                          "image_url": image
                        ],
                        "channel" => params[:channel_id]}.to_json,
                headers: {'content-type' => 'application/json'}
end

