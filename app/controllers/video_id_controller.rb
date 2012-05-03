require File.expand_path("../../../lib/rebuild/video_id_show", __FILE__) 

class VideoIdController < ApplicationController
  
  #节目-视频分类和过滤条件输入页
  def input
    respond_to do |format|
      format.html
    end
  end

  #根据节目-视频的分类和过滤条件返回对应的视频ID
  #可以支持分页
  def show
    filter_str = params[:filter_str]
    page = params[:page].to_i
    respond_to do |format|
      if(filter_str.nil? || page.nil?)
        format.html{redirect_to action:"input"}
      else
        @video_ids = VideoIdShow.get_all_video_id_by_filter_and_page(filter_str, page)
        format.html
      end
    end
  end

end
