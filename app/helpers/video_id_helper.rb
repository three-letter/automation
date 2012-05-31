require 'open-uri'

module VideoIdHelper
  
  #视频ID字符数字转码
  def vid_decode vid_str
    return "" if vid_str.nil? || vid_str.empty?
    url = "http://testprogram.youku.com/index/temp/urlencode/test.php?videoiddecode=#{vid_str}"
    doc = open(url).read
    vid_regx = doc.match(/videodecode\s+(\d+)/)
    if vid_regx.nil?
      return ""
    else
      return vid_regx[1]
    end
  end


end
