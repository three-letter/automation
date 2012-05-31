#coding: utf-8
#require File.expand_path("../../../lib/rebuild/index_builder", __FILE__)

class BuilderController < ApplicationController
  #索引重构的操作页
  def index
    @rebuild = Rebuild.new
    respond_to do |format|
      format.html
    end
  end

  #根据请求重构对应的索引
  def rebuild
    @rebuild = Rebuild.new
    @rebuild.init(params[:type], params[:state], params[:flag], params[:category])
    valid_msg = @rebuild.check_validate
    respond_to do |format|
      if valid_msg.empty?
        flash[:notice] = @rebuild.rebuild_index
        flash[:notice] = "未进行任何操作！" if flash[:notice].empty?
      else
        flash[:notice] = valid_msg
      end
      format.js
    end
  end

  #测试url
  def test
    respond_to do |format|
      format.html
    end
  end

end
