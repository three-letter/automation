require 'open-uri'
require 'digest'
require 'json'

class AppInfoController < ApplicationController
 
  before_filter :get_host
  #各种参数输入页
  def index
  end
  
  #获取access_token
  #先根据appid获取 ckey secret，结合grant_type对应数据
  def show
    appid = params[:app_info_appid_input] 
    ckey = params[:app_info_ckey_input]
    grant_type = params[:app_info_grant_type_input]
    code = params[:app_info_code_input]
    redirect_uri = params[:app_info_redirect_uri_input]
    username = params[:app_info_username_input]
    password = params[:app_info_password_input]
    logintype = params[:app_info_logintype_input]
    refresh_token = params[:app_info_refresh_token_input]
    flash[:notice] = check_params(appid,ckey,grant_type)
    password = Digest::MD5.hexdigest(password) if !password.empty?
    if !appid.empty?
      ckey,secret = get_app_info_by_appid appid
    else 
      ckey,secret = get_app_info_by_ckey ckey if !ckey.empty?
    end
    respond_to do |format|
      if flash[:notice].nil?
        flash[:notice] = get_access_token_info(grant_type,ckey,secret,code,redirect_uri,username,password,logintype,refresh_token) 
      end
      format.html
    end

  end

  private

    def check_params *args
      return "appid, ckey all empty!" if args[0].empty? && args[1].empty?
      return "grant_type is empty!" if args[2].empty?
    end

    def get_app_info_by_appid appid
      url = @host + "/oauth2/app_info?appid=#{appid}"
      doc = open(url).read
      json = JSON doc
      ckey, secret = json["data"]["ckey"], json["data"]["secret"]
    end
    
    def get_app_info_by_ckey ckey
      url = @host + "/oauth2/app_info?ckey=#{ckey}"
      doc = open(url).read
      json = JSON doc
      ckey, secret = json["data"]["ckey"], json["data"]["secret"]
    end

    def get_access_token_info *args
      grant_type = args[0]
      url = @host + "/oauth2/access_token?grant_type=#{args[0]}&client_id=#{args[1]}&client_secret=#{args[2]}"
      case grant_type
      when "authorization_code"
        url += "&code=#{args[3]}&redirect_uri=#{args[4]}"
      when "password"
        url += "&username=#{args[5]}&password=#{args[6]}"
      when "refresh_token"
        url += "&logintype=#{args[7]}&refresh_token=#{args[8]}"
      else
        return ""
      end
      json = JSON open(url).read
      refresh_token,access_token = "refresh_token:#{json["data"]["refresh_token"]}", "access_token:#{json["data"]["access_token"]}"
    end
    def get_host
      host = params[:app_info_host_input].to_i
      case host
      when 0
        @host = "http://10.103.88.179:8070" # 线上正式环境
      when 1
        @host = "http://10.10.221.107:8000" # 线下测试环境
      else
        @host = ""
      end
    end
end
