class MonitorController < ApplicationController
  @@USER_FILE = "/home/linson/work/demo/mail/to.txt"
  @@URL_FILE = "/home/linson/work/demo/searchd/url.txt"
  def show
    @users = get_info_by_txt(@@USER_FILE)
    @urls = get_info_by_txt(@@URL_FILE)
    respond_to do |format|
      format.html
    end
  end

  def update
    user = params[:monitor_user_input]
    url = params[:monitor_url_input]
    begin
      users = user.split("\n")
      urls = url.split("\n")
      update_info_by_txt(@@USER_FILE, users)
      update_info_by_txt(@@URL_FILE, urls)
    rescue
      flash[:notice] = "Save Fail !"
    end
    respond_to do |format|
      flash[:notice] = "Save Success !" if flash[:notice].nil?
      format.html
    end
  end

  private 
    #逐行读取指定文件的数据
    def get_info_by_txt file
      info = []
      File.open(file,"r") do |f|
        f.each_line do |l|
          info << l.strip
        end
      end
      info
    end

    #更新指定文件的数据
    def update_info_by_txt(file, arry)
      File.open(file,"w") do |f|
        arry.each do |a|
          f.puts(a)
        end
      end
    end

end
