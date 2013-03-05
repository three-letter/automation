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
    
    #转码视频 节目id
    def get_encode_id vid_str
      return "" if vid_str.nil? || vid_str.empty?
      url = "http://testprogram.youku.com/index/temp/urlencode/test.php?videoidencode=#{vid_str}"
      doc = open(url).read
      vid_regx = doc.match(/videoencode\s+(.+?)<br>/)
      if vid_regx.nil?
        return ""
      else
        return vid_regx[1]
      end
    end
    
    #解码码视频 节目id
    def get_decode_id vid_str
      return "" if vid_str.nil? || vid_str.empty?
      url = "http://testprogram.youku.com/index/temp/urlencode/test.php?videoiddecode=#{vid_str}"
      doc = open(url).read
      vid_regx = doc.match(/videodecode\s+(\d+)/)
      if vid_regx.nil?
        return ""
      else
        return vid_regx[1]
      end
    end
end
