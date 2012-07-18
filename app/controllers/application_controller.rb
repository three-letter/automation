require 'open-uri'
require 'json'

class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    def get_uid_by_name name
      url = "http://10.103.24.11:8081/passport/get_by_user?username=#{name}"
      doc = open(url).read
      json = JSON doc
      json["data"]["uid"]
    end
end
