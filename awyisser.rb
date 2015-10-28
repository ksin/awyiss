require "net/http"
require "uri"
require "json"
require "cgi"

module AwYisser
  URL = ["http://awyisser.com/api/generator", "http://ink1001.com/p/lp/116570e1643601f3.png"]

  def awyissify(phrase)
    if phrase.length > 40
      return "aw nooo... your phrase is too long! (40 chars max)"
    end
    "#{get_image(phrase, false)}"
  end

  def get_image(phrase, use_awyisser_dot_com)
    params = {"phrase" => phrase}
    params["sfw"] = true if sfw # required to only add sfw key conditionally because {"sfw" => false} still registers as true
    if use_awyisser_dot_com
      response = http_post_request(URL[0], params)
      return JSON.parse(response.body)["link"]
    end
    "#{URL[1]}?#{parameterize(params)}"
  end

  def parameterize(params)
    encoded_params = params.collect do |k,v|
      if v.is_a? String
        v = CGI::escape(v)
      end
      "#{k}=#{v}"
    end
    encoded_params.join('&')
  end

  def http_post_request(url, data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)
    http.request(request)
  end
end
