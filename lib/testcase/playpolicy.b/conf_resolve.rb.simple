
#解析conf策略文件，生成对应的hash数据 testcase数据
module ConfResolve

  #根据测试环境类型，读取对应的策略配置文件
  def init_file type
    conf_file = type.to_i == 0 ? "ontest_conf.txt" : "online_conf.txt"
    case_file = type.to_i == 0 ? "ontest_case.txt" : "online_case.txt"
    @conf_file = File.expand_path("../#{conf_file}", __FILE__)
    @case_file = File.expand_path("../#{case_file}", __FILE__)
  end
  
  def match_p2p_conf param_hash
    confs = get_p2p_conf_data
    m, mi = match_conf(param_hash, confs)
    m = m ? 1 : 0
    match, match_info = m, mi
  end
  
  def match_tudou_cdn_conf param_hash
    confs = get_tudou_cdn_conf_data
    m, mi = match_conf(param_hash, confs)
    m = m ? "youku" : "tudou"
    match, match_info = m, mi
  end

  #根据参数匹配策略配置信息
  def match_conf param_hash, confs
    match = false
    match_info = [] #匹配信息 依次命中的具体值
    #confs = get_p2p_conf_data
    confs.each_with_index do |conf, index|
      conf.keys.each do |k|
        value = conf[k]
        m_value = ",#{value},"
        k += "_encode" if k == "vid"
        param = param_hash[k]
        next if param.nil?
        #是否完全命中策略配置信息
        match = m_value.include?(",#{param},")
        match_info << param if match
        #对于未完全命中的area_code，需进行做匹配 -匹配验证
        if k == "area_code" && !match
          value.split(",").each do |v|
            if param.index(v) == 0 #左匹配
              match = true 
              match_info << v
            end
            if v.include?("-") && "-#{param}".index("#{v}") == 0 #-匹配
              match = false 
              match_info << v
            end
          end
        end
        break if !match
      end
      break if match
    end
    match_c, match_info_conf = match, match_info.uniq
  end

  #获取p2p策略配置信息
  def get_p2p_conf_data
    datas = get_file_data
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

  #获取tudou cdn策略配置信息
  def get_tudou_cdn_conf_data
    datas = get_file_data
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

  #获取player策略配置信息
  def get_player_conf_data
    datas = get_file_data
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


  #读取文件数据
  def get_file_data
    data_str_arry = []
    File.open(@conf_file,"r") do |f|
      while line = f.gets
        data_str_arry << line.strip
      end
    end
    data_str_arry.join
  end

  #读取文件原格式数据
  def get_file_format_data
    data_str_arry = get_conf_info 
    data_str_arry.join
  end
  
  def get_conf_info
    data_str_arry = []
    File.open(@conf_file,"r") do |f|
      while line = f.gets
        data_str_arry << line
      end
    end
    data_str_arry
  end


  #更新conf配置信息
  def update_conf_info infos
    File.open(@conf_file,"w") do |f|
      infos.each do |info|
        f.puts(info)
      end
    end
  end

  def get_case_info
    data_str_arry = []
    File.open(@case_file,"r") do |f|
      while line = f.gets
        data_str_arry << line
      end
    end
    data_str_arry
  end


  #更新conf配置信息
  def update_case_info infos
    File.open(@case_file,"w") do |f|
      infos.each do |info|
        f.puts(info)
      end
    end
  end


end
