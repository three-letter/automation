require 'json'
require File.expand_path("../case_util", __FILE__)
require File.expand_path("../conf_util", __FILE__)

#解析conf策略文件，生成对应的hash数据 testcase数据
class ConfResolve
  extend CaseUtil
  extend ConfUtil
  
  class << self
    #通过testcase数据和conf配置信息，获取testcase预期结果集
    def get_expect_info param_hash, point
      self.send("get_#{point}_expect_info".to_sym, param_hash)
    end

    #获取p2p预期结果集
    def get_p2p_expect_info param_hash
      match = false
      match_info = [] #匹配信息 依次命中的具体值
      confs = get_conf_info("p2p")
      confs.each_with_index do |conf, index|
        conf.keys.each do |k|
          value = conf[k]
          m_value = ",#{value},"
          #k += "_encode" if k == "vid"
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
      match_c, match_info_conf = match ? 1 : 0 , match_info.uniq
    end

    #获取tudou_cdn预期结果集
    def get_tudou_cdn_expect_info param_hash
      debugip = param_hash["debugip"]
      #param_hash["debugip"] = "60.247.104.110" if debugip.nil? || debugip.empty?
      #doc = open("http://10.103.21.121/query.php?ip=#{param_hash['debugip']}").read
      #json = JSON doc
      #d, a = json["d"].to_s, json["a"].to_s
      #param_hash = Hash[["dma_code","area_code"].zip([d,a])]
      param_hash = get_code_by_ip debugip 
      match = false
      match_info = [] #匹配信息 依次命中的具体值
      confs = get_conf_info("tudou_cdn")
      confs.each_with_index do |conf, index|
        conf.keys.each do |k|
          value = conf[k]
          m_value = ",#{value},"
          #k += "_encode" if k == "vid"
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
      match_c, match_info_conf = match ? "youku" : "tudou" , match_info.uniq
    end

    #获取player预期结果集
    def get_player_expect_info param_hash
      #TODO need test the param with ip
      match, pr = false, "player"
      match_info = [] #匹配信息 依次命中的具体值
      key_confs = get_conf_info("player")
      key_confs.each_with_index do |key_conf,i|
        player = key_conf.keys[0]
        conf = key_conf.values[0]
        conf.keys.each do |k|
          value = conf[k]
          m_value = ",#{value},"
          #k += "_encode" if k == "vid"
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
        if match
          pr = player
          break
        end
      end
      match_c, match_info_conf = pr , match_info.uniq
    end

 end

end

#cs = ConfResolve.new
# ConfResolve.init_conf_file 0

#cs.init_case_file(0,"p2p")
#p2p_param_hash = {"vid_encode" => 107645364 }
#puts cs.get_expect_info(p2p_param_hash,"p2p")

#cs.init_case_file(0,"tudou_cdn")
#tudou_cdn_param_hash = {"debugip" => "60.247.104.110" }
#puts cs.get_expect_info(tudou_cdn_param_hash, "tudou_cdn")

# ConfResolve.init_case_file(0,"player")
#player_param_hash = {"category" => "102" }
#puts  ConfResolve.get_expect_info(player_param_hash, "player")


