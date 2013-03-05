#coding: utf-8
require 'net/ssh'

class MessagepoolController < ApplicationController

  # 根据视频id查询消息系统中对应的消息
  def seq
  end

  def get
    vid = params[:vid]
    @msg = ""
    if vid.nil? || vid.empty?
      @msg = "视频ID不能为空"
    else
      @msg = get_msg(vid)
    end
    puts "Message: #{@msg}"
    respond_to do |format|
      format.js
    end
  end

  private
    def get_msg(vid)
      msg = ""
      vid = get_decode_id(vid) if vid.to_i == 0
      host,user,pwd,port = "10.10.221.104", "root", "111111", 22022
      Net::SSH.start(host, user, :password => pwd, :port => port) do |ssh|
        msg = ssh.exec!("cd /opt/video/builder/video && php mq_scan.php -t youku.show.video_change -k vid -o 55313796 -v " + vid)
      end
      msg       
    end
end
