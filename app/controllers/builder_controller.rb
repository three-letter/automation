#coding: utf-8
require File.expand_path("../../../lib/rebuild/index_builder", __FILE__)

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
    valid_msg = @rebuild.check_validate
    if valid_msg.empty?
      flash[:notice] = @rebuild.rebuild_index
    else
      flash[:notice] = msg
    end
  end

  #测试url
  def test
    respond_to do |format|
      format.html
    end
  end

end
