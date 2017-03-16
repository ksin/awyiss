require "net/http"
require "uri"
require "json"
require "cgi"

module Awyisser
  URL = ["http://awyisser.com/api/generator", "http://ink1001.com/p/lp/116570e1643601f3.png"]

  USE_AWYISSER_DOT_COM = false

  def self.image_url(phrase, sfw)
    if phrase.length > 40
      return "aw nooo... your phrase is too long! (40 chars max)"
    end
    "#{fetch(phrase, sfw)}"
  end

  private

  def self.fetch(phrase, sfw)
    params = {"phrase" => phrase}
    params["sfw"] = true if sfw # required to only add sfw key conditionally because {"sfw" => false} still registers as true
    if USE_AWYISSER_DOT_COM
      awyisser_dot_com_url(params)
    else
      movable_ink_url(params)
    end
  end

  def awyisser_dot_com_url(params)
    response = http_post_request(URL[0], params)
    JSON.parse(response.body)["link"]
  end

  def self.http_post_request(url, data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)
    http.request(request)
  end

  def self.movable_ink_url(params)
    encoded_params = params.collect do |k,v|
      if v.is_a? String
        v = CGI::escape(v)
      end
      "#{k}=#{v}"
    end
    "#{URL[1]}?#{encoded_params.join('&')}"
  end

end
