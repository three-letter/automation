require 'rexml/document'

#testcase xml文件解析工具
module CaseXmlUtil
	
	#init xml path
	def init_xml xml
		#xml_path = File.expand_path("../#{xml}", __FILE__)
		xml_file = File.open(xml)
		@doc = REXML::Document.new(xml_file)
	end

	#获取testcase的测试环境
	def get_case_base node
		host= []
		@doc.elements.each("testcase/#{node}") do |h|
			host << h.text.strip
		end
		host.join
	end

	#根据testcase的数据组合返回对应的url 预期值和描述
	def get_test_case
		test_cases = []
		host = get_case_base("host")
		@doc.elements.each("//case") do |c| 
			test_case_hash = Hash.new
			url = host
			#初始化url
			c.elements.each("param") do |p|
				name = p.attributes["name"].strip
				next if name.nil? || name.empty?
				value = p.text.strip
				url += "#{name}=#{value}&"
			end
			#初始化result
			rst = c.elements["result"]
			keys = ["type", "source", "value"]
			values = keys.map { |k| rst.elements["#{k}"].text }
			r_hash = Hash[keys.zip(values)] 
			#初始化case desc
      #d_hash = Hash.new
			desc = c.elements["desc"].text
      #d_hash["desc"] = desc
		  # 初始化实际值节点	
      fact = c.elements["fact"].text
      #case数据组装
			test_case_hash["url"] = url
      test_case_hash["fact"] = fact
			test_case_hash["result"] = r_hash
			test_case_hash["desc"] = desc

			test_cases << test_case_hash
		end
		test_cases
	end

end

=begin
xml = CaseXmlUtil.new
file = File.expand_path("../example.xml", __FILE__)
xml.init_xml(file)
#puts xml.get_case_host
puts xml.get_test_case
=end
