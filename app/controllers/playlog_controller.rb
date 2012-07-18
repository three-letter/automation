class PlaylogController < ApplicationController
  def index
  end

  def show
    name = params[:playlog_user_input]
    guid = params[:playlog_guid_input]
    type = params[:playlog_type_input]
    flash[:notice] = "User_Name is empty!" if name.empty?
    respond_to do |format|
      if flash[:notice].nil?
        if type == "user"
          uid = get_uid_by_name name
        else
          uid = guid
        end
        #查询token
        token_url = "http://10.103.17.1/token/get.json?identity_num=#{uid}&identity_type=#{type}"
        doc = open(token_url).read
        json = JSON doc
        token = json["data"]["token"]
        #查询playlog
        playlog_url = "http://10.103.17.1/playlog/get.json?token=#{token}"
        pdoc = open(playlog_url).read
        pjson = JSON pdoc
        playlog = pjson["data"]
        flash[:notice] = JSON.generate token:token, playlog:playlog.to_a
        format.html
      end
    end
  end


end
