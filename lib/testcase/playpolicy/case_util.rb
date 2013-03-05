require File.expand_path("../file_util", __FILE__)

module CaseUtil
  include FileUtil

  #初始化testcase数据文件
  def init_case_file host, point
    point = "p2p" if point.nil?
    case_file = host > 0 ? "case_online.txt" : "case_ontest.txt"
    if point && !point.empty?
      case_file = "#{point}_#{case_file}"
      @point = point
    end
    @case_file = File.expand_path("../#{case_file}", __FILE__)
  end

  #读取对应方法的testcase数据
  def read_case_file
    read_string_info(@case_file,"")
  end
  
  #写入对应方法的testcase数据
  def write_case_file infos
    write_array_info(@case_file, infos)
  end

  #解析testcase获取参数集 case集
  def get_cases
    cases = read_array_info @case_file
    test_case = []
    cases.each do |c|
      ps = []
      c.split(/-/).each do |p|
        p = p.strip
        #p = "vid_encode" if p == "vid"
        ps << p
      end
      test_case << ps
    end
    test_case
  end

  #### 根据testcase获取param_hash ####
  def get_param_hash
    self.send("get_#{@point}_param_hash".to_sym)
  end

  #获取p2p param_hash
  def get_p2p_param_hash
    param_hashs = []
    cases = get_cases
    return param_hashs if cases.length == 0
    param_name_array = cases[0]
    cases.each_with_index do |c,i|
      next if i == 0
      param_hash = Hash[param_name_array.zip(c)]
      param_hashs << param_hash
    end
    param_hashs
  end

  #获取tudou_cdn param_hash
  def get_tudou_cdn_param_hash
    get_p2p_param_hash
  end

  #获取player param_hash
  def get_player_param_hash
    get_p2p_param_hash
  end

  #获取case组合的url集
  def get_url host
    self.send("get_#{@point}_url".to_sym,host)
  end

  #获取p2p的testcase组合url
  def get_p2p_url host
    urls = []
    cases = get_cases
    return param_hash if cases.length == 0
    param_name_array = cases[0]
    cases.each_with_index do |c,i|
      next if i == 0
      url = host
      c.each_with_index do |p,pi|
        next if p.empty?
        if param_name_array[pi] == "vid"
          p_encode = get_encode_id p
          url += "vid_encode=#{p_encode}&"
        else
          url += "#{param_name_array[pi]}=#{p}&"
        end
      end
      urls << url
    end
    urls
  end

  #获取tudou_cdn的testcase组合url
  def get_tudou_cdn_url host
    get_p2p_url host
  end

  #获取player的testcase组合url
  def get_player_url host
    get_p2p_url host
  end

end

=begin
cu = CaseUtil.new
cu.init_case_file(0,"p2p")
puts "case size: #{cu.get_cases.size}"
puts cu.get_param_hash
=end
