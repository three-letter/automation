module MonitorHelper
  #显示待监控用户email和中间层服务
  def text_area_show arry
    info = ""
    arry.each do |a|
      info += a.strip + "\n"
    end
    info
  end

end
