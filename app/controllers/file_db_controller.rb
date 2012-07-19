require 'open-uri'
require 'hpricot'

class FileDbController < ApplicationController
  @@TEST_HOST = "http://10.10.221.101/video.video?"
  @@PHANTOM_HOST = "http://10.103.12.71/video.video?"
  @@ONLINE_HOST = "http://10.103.12.71/video.video?"

  def index
  end

  def get_video
    host = params[:host]
    source = params[:datasource]
    vids, titles = get_video_by_host_and_source(host,source)
    @videos = vids.zip(titles) 
    respond_to do |format|
      format.js
    end
  end

  private 
    def get_video_by_host_and_source host, source
      url = ""
      case host
      when 0
        url += @@TEST_HOST
      when 1
        url += @@PHANTOM_HOST
      when 2
        url += @@ONLINE_HOST
      end
      if source == 0 #pc端 
        url += "q=source%3A1" 
      else #无线端 source:10010-10011
        url += "q=source%3A10010-10011"
      end
      url += " state%3Anormal&fc=&fd=title source&pn=1&pl=10&ob=createtime%3Adesc&ft=json&cl=test_page&h=1"
      vid, title = [], []
      HPricot(open(url)) do |doc|
        doc.search("tr[@valign=top]/td/a") do |a|
          vid << a.inner_html 
        end
        doc.search("tr[@valign=top]/td") do |t|
          title << t.inner_html
        end
      end
    end

end
