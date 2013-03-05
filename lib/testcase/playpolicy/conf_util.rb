require File.expand_path("../file_util", __FILE__)

module ConfUtil
  include FileUtil  

  #初始化conf配置文件
  def init_conf_file host
    conf_file = host > 0 ? "conf_online.txt" : "conf_ontest.txt"
    @conf_file = File.expand_path("../#{conf_file}", __FILE__)
  end

  #读取对应方法的conf数据
  def read_conf_file
    read_string_info(@conf_file,"")
  end
  
  #写入对应方法的conf数据
  def write_conf_file infos
    write_array_info(@conf_file, infos)
  end

  #获取conf对应point配置信息
  def get_conf_info point
    self.send("get_#{point}_conf_info".to_sym)
  end

  #获取p2p配置信息
  def get_p2p_conf_info
    datas = read_string_info(@conf_file)
    values = []
    datas.scan(/p2p{(.+?)}/).each_with_index do |data,index|
      value = data[0]
      h = Hash.new
      value.split(";").each do |v|
        param = v.split(/\s+/)[0]
        val = v.split(/\s+/)[1]
        h[param] = val
      end
      values << h
    end
    values
  end

  #获取tudou_cdn配置信息
  def get_tudou_cdn_conf_info
    datas = read_string_info(@conf_file)
    values = []
    datas.scan(/tudou_cdn{(.+?)}/).each_with_index do |data,index|
      value = data[0]
      h = Hash.new
      value.split(";").each do |v|
        param = v.split(/\s+/)[0]
        val = v.split(/\s+/)[1]
        h[param] = val
      end
      values << h
    end
    values
  end

  #获取player配置信息
  def get_player_conf_info
    datas = read_string_info(@conf_file)
    values = []
    datas.scan(/(player_\w+?){(.+?)}/).each_with_index do |data,index|
      key = data[0]
      value = data[1]
      h = Hash.new
      value.split(";").each do |v|
        param = v.split(/\s+/)[0]
        val = v.split(/\s+/)[1]
        h[param] = val
      end
      hash = Hash.new
      hash[key] = h
      values << hash
    end
    values
  end

end

=begin
cu = ConfUtil.new
cu.init_conf_file(0)
puts "p2p conf: #{cu.get_conf_info('p2p')}"
puts "tudou_cdn conf: #{cu.get_conf_info('tudou_cdn')}"
puts "player conf: #{cu.get_conf_info('player')}"
=end
