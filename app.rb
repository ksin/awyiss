require 'sinatra'
require_relative 'awyiss'

post '/awyiss' do
  SlackBot::AwYiss.new(params[:channel_id], params[:text]).post_to_slack
end
