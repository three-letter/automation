#coding: utf-8
require "/home/halsey/work/ruby/rails/automation/lib/rebuild/index_builder.rb"

class BuilderController < ApplicationController
  #索引重构的操作页
  def index
    respond_to do |format|
      format.html
    end
  end

  #根据请求重构对应的索引
  def rebuild
    type = params[:operate_type].to_i
    video_id = params[:operate_video_id]
    area = params[:operate_area]
    respond_to do |format|
      if (type == 0)
        flash[:notice] = "操作类型不能为空!"
        #format.html{render action:"index"}
        format.js
      else
        if(video_id.blank? && type < 3)
          flash[:notice] = "节目ID不能为空!"
          format.js
        else
          flash[:notice] = IndexBuilder.build(type, video_id, area)
          #format.html{redirect_to action:"index"}
          format.js
        end
      end
    end
  end

  #测试url
  def test
    respond_to do |format|
      format.html
    end
  end

end
