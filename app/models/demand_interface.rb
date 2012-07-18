#coding:utf-8
require File.path(Rails.root) + "/lib/json/json_util"

class DemandInterface < ActiveRecord::Base
  include JsonUtil
  attr_accessible :child_interface_id, :demand_id, :interface_id, :params

  #根据参数-关联json结果对应关系返回结果
  #如根据uname返回的uid，作为参数获取token
  def get_results *args
    if @child_interface_id == 0
      interface = Interface.find(@interface_id)
      return interface.get_results *args
    else
      children_interface = Interface.find(@children_interface_id)
      children_results = children_interface.get_results *args
    end
  end

end
