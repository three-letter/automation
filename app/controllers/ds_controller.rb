#coding:utf-8
require 'open-uri'
require 'json'

class DsController < ApplicationController
  
  #节目信息写入：根据节目ID从中间层获取节目信息，根据需求修改后进行写入
  def show
    respond_to do |format|
      format.html
    end
  end

  def show_info
    show_id = params[:ds_show_input]
    #从中间层获取数据
    fd1 = "showcategory%20showname%20showsubtitle%20releasedate%20"
    fd2 = "showalias%20showkeyword%20source%20showkeyword%20"
    fd3 = "area%20source%20"
    fd4 = "distributor%20tudou_num%20"
    fd5 = "production%20performer%20"
    url = "http://10.10.221.101/show.show?q=showid%3A#{show_id}&fc=&fd=#{fd1}%20#{fd2}%20#{fd3}%20#{fd4}%20#{fd5}&pn=1&pl=2&ob=showid%3Aasc&ft=json&cl=test_page&h=3"
    respond_to do |format|
      flash[:info] = get_data(open(url).read) 
      format.js
    end
  end

  private
    def get_data data_str
      index = data_str.index("\"results\"")
      rep = data_str[1,index-1]
      data_str = data_str.gsub(rep,"\"version\":\"1.0\",")
      data_str = data_str.gsub("results","dataset")
      data_str = data_str.gsub(/,"total_cost.*\d+/,"")
      data_str
    end
end
