
require File.expand_path("../../../lib/testcase/playpolicy/conf_resolve", __FILE__)
require 'open-uri'
require 'json'

class PlaypolicyController < ApplicationController

  before_filter :init_conf_file

  def index
    #获取conf配置文件信息
    @conf = ConfResolve.read_conf_file
    @case = ConfResolve.read_case_file
  end

  def show
    @conf = ConfResolve.read_conf_file
    @case = ConfResolve.read_case_file

    #保存更新新后的conf case数据
    conf_p = params[:test_conf]
    conf_infos = get_array_info conf_p
    case_p = params[:test_case]
    case_infos = get_array_info case_p
    ConfResolve.write_conf_file(conf_infos)
    ConfResolve.write_case_file(case_infos)

    #根据host cases生成对应的url param_hash
    host = params[:test_host]
    @param_hashs = ConfResolve.get_param_hash
    @urls = ConfResolve.get_url host
    

    #根据实际urls和param_hashs返回对应的实际结果和预期结果
    @expects, @facts, @match_infos = [], [], []
    point = params[:test_point]
    @param_hashs.each do |hash|
      match_array = ConfResolve.get_expect_info(hash,point)
      @expects << match_array[0]
      @match_infos << match_array[1]
    end
    @urls.each do |url|
      fact = 0
      json = get_url_json url
      @facts << -1 if json.nil?
      case point
        when "p2p"
          begin
            fact = json["dataset"]["p2p"][0]["allow"]
          rescue
            fact = -1
          end
        when "tudou_cdn"
          begin
            fact = json["data"][0]["player"]
          rescue
            fact = -1
          end
        when "player"
          begin
            fact = json["dataset"]["p2p"][0]["player"]
          rescue
            fact = -1
          end
        else
          fact = 0
      end
      @facts << fact
    end

    render action:"show"
  end

  def new
  end
  
  #更改测试环境，动态显示conf，cases信息
  def change_envir
    @conf = ConfResolve.read_conf_file
    @case = ConfResolve.read_case_file
    respond_to do |format|
      format.js
    end
  end

  #更改测试点，动态显示cases信息
  def change_point
    @conf = ConfResolve.read_conf_file
    @case = ConfResolve.read_case_file
    respond_to do |format|
      format.js
    end
  end

  private

    #根据指定测试环境初始化conf配置文件
    def init_conf_file
      type = params[:test_envir].to_i
      point = params[:test_point]
      ConfResolve.init_conf_file(type)
      ConfResolve.init_case_file(type,point)
    end

    #根据输入信息逐行返回数组
    def get_array_info param_info
      infos = []
      param_info.split("\n").each do |c|
        c = c.strip
        next if c.empty?
        infos << c
      end
      infos
    end

    #根据url返回json
    def get_url_json url
      json = nil
      begin
        doc = open(url).read
        json = JSON doc
      rescue
        json = nil
      end
      json
    end

end
