require 'open-uri'
:q

module FileUtil  
  #逐行读取文件信息，返回数组
  def read_array_info *args
    file = args[0]
    infos = []
    File.open(file, "r") do |f|
      while line = f.gets
        line = line.strip if args.length > 1
        infos << line
      end
    end
    infos
  end

  #逐行读取文件信息，返回string，可有分隔符
  def read_string_info *args
    file = args[0]
    if args.length == 1
      infos = read_array_info(file,"")
      return infos.join
    else
      infos = read_array_info(file)
      return infos.join
    end
  end
  
  #写入数组数据到文件
  def write_array_info file, infos
    File.open(file, "w") do |f|
      infos.each do |info|
        f.puts info
      end
    end
  end

  #根据ip获取dma_code area_code
  def get_code_by_ip ip
    ip = "60.247.104.110" if ip.nil? || ip.empty?
    doc = open("http://10.103.21.121/query.php?ip=#{ip}").read
    json = JSON doc
    d, a = json["d"].to_s, json["a"].to_s
    param_hash = Hash[["dma_code","area_code"].zip([d,a])]
  end

  #多次使用videoid的编码和解码，故挪到这
  def get_encode_id vid_str
    return "" if vid_str.nil? || vid_str.empty?
    url = "http://testprogram.youku.com/index/temp/urlencode/test.php?videoidencode=#{vid_str}"
    doc = open(url).read
    vid_regx = doc.match(/videoencode\s+(.+?)<br>/)
    if vid_regx.nil?
      return ""
    else
      return vid_regx[1]
    end
  end
 
  #解码码视频 节目id
  def get_decode_id vid_str
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

