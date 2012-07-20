require 'open-uri'
require 'hpricot'

class FiledbController < ApplicationController
  
  before_filter :init_host
  
  def index
  end

  #ajax获取视频信息
  def show
    source = params[:filedb_datasource] 
    @vids = get_video source.to_i
    respond_to do |format|
      format.js
    end
  end

  #判断接口是否正确
  def check
    vids = params[:filedb_vid]
    value = params[:filedb_value]
    @results = check_value(vids,value.to_i)
    respond_to do |format|
      format.js
    end
  end

  private
    def check_value vids, value
      return [[],[]] if vids.nil? || vids.length == 0
      s, f = [], []
      vids = vids.split(", ")
      vids.each do |v|
        url = @filedb_get + v
        begin
          open(url)
          s << v if value == 1
          f << v if value == 0
        rescue
          f << v if value == 1
          s << v if value == 0
        end
      end
      [s,f]
    end
  
    def get_video source
      url = @host
      if source > 0 #无线端：10010-10011
        url += "q=source:10010-10011"
      else #站内PC端：1
        url += "q=source:1"
      end
      url += " state:normal&fc=&fd=title source&pn=1&pl=10&ob=createtime:desc&ft=json&cl=test_page&h=1"
      vids = []
      url = URI.encode(url)
      doc = Hpricot(open(url))
      doc.search("tr[@valign=top]/td/a") do |a|
        vids << a.inner_text
      end
      vids
    end
    
    def init_host
      host = params[:filedb_host]
      @host = "" if host.nil?
      case host.to_i
      when 0
        @host = "http://10.10.221.101/video.video?"
        @filedb_get = "http://10.10.221.104:8088/filedb/video/shootinfo/get.json?vid="
      when 1
        @host = "http://10.103.12.71/video.video?"
        @filedb_get = "10.103.12.131/filedb/video/shootinfo/get.json?vid="
      when 2
        @host = "http://10.103.12.71/video.video?"
        @filedb_get = "10.103.12.131/filedb/video/shootinfo/get.json?vid="
      end
    end
end
