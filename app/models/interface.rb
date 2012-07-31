#coding:utf-8
require File.path(Rails.root) + "/lib/json/json_util"

class Interface < ActiveRecord::Base
  include JsonUtil
  attr_accessible :host, :param, :result
  
  belongs_to :demand
  has_many   :params

  #根据输入的参数值查询指定的结果
  def get_results *args
    url = @host + "?"
    @params = @params.gsub("：",":")
    params_values = @params.split(":") 
    results_values = @results.split(":")
    return "参数不完整！" if params_values.length > args.lenght
    params_value.each_with_index do |param,index|
      url += "#{param}=#{args[index]}&"
    end
    get_results(results_values,url)
  end

end
