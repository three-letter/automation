#coding:utf-8
require 'json'
require 'open-uri'

module Layer

	#获取key在指定json的layer
	def get_layer key, url
		doc = open(url).read
		return "该JSON中不存在节点：#{key}！" unless doc.include?("\"#{key}\"")
		return "该JSON中：#{key}为数组节点！" if doc.scan(/"#{key}"/).length > 1
		json = JSON doc
		layer = []
		top = nil
		while top.nil? do
			top = get_top_layer key,json
			if top 
				layer << key
				break
			end
			children_json = get_children_json key, json
			children_key = children_json[0]
			json_str = children_json[1].gsub("=>",":")
			json_str = json_str.gsub("\":nil,","\":\"null\",")
			begin
				json = JSON json_str
				layer << children_key
			rescue
				puts "error"
				break
			end
		end
		layer
	end
	
	#获取指定json的顶级key
	def get_top_layer key, json
		keys = get_json_keys json
		return key if keys.include?key
	end

	#根据key获取指定json的子级json
	def get_children_json key, json
		children_json , children_key = "", ""
		keys = get_json_keys json
		values = get_json_values json
		values.each_with_index do |v,i|
			if v.to_s.include?("\"#{key}\"")
				children_json = v.to_s
				children_key = keys[i]
				break
			end
		end
		[children_key, children_json]
	end
	
	#获取指定json的全部顶级key
	def get_json_keys json
		keys = []
		json.each do |j|
			keys << j.to_a[0]
		end
		keys
	end
	
	#获取指定json的全部顶级value
	def get_json_values json
		values = []
		json.each do |j|
			values << j.to_a[1]
		end
		values
	end
	
end

