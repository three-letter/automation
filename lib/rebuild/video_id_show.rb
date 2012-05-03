#coding: utf-8
require 'watir-webdriver'
require 'open-uri'
require 'hpricot'

class VideoIdShow
	#节目-视频的默认全部页
	@@base_url = "http://www.youku.com/v/"
	
#### 定义类方法 start ####
	class << self

		#判断返回的数据是否为url
		def is_url url
			return url =~ /http/
		end
			
		#获取指定页数的节目-视频的全部视频ID
		def get_all_video_id_by_filter_and_page(filter_str, page)
			all_video_id = Array.new
			url_array = get_url_arry_by_filter_and_page(filter_str, page)
			url_array.each do |url|
				if is_url url
					all_video_id << get_video_id_arry(url)
				else
					all_video_id << url
				end
			end
			all_video_id.flatten
		end

		#在筛选的条件下获取指定页数的url
		def get_url_arry_by_filter_and_page(filter_str, page)
			url_array = Array.new
			base_url = generate_url filter_str
			url_array << base_url
			if (page > 1 && is_url(base_url))
				b = Watir::Browser.new :ie
				b.goto base_url
				page_area = b.ul(:class, "pages")
				2.upto(page) do |p|
					page_area.link(:text, "#{p}").click
					b.wait
					url_array << b.url
				end
				b.close
			end
			url_array
		end
		
		#根据视频分类和筛选条件返回对应的url,各条件以空格分隔 输入格式为 type filter filter 
		def generate_url filter_str
			url = ""
			filter_str = filter_str.strip
			return "没有选择视频分类!" if filter_str.empty?
			filters = filter_str.split(/\s+/)
			type = filters[0]
			b = Watir::Browser.new :firefox
			b.goto @@base_url
			tree = b.ul(:class, "tree")
			begin
				type_link = tree.link(:text, type)
				type_link.click
			rescue
				b.close
				return "不存在的视频分类:\"#{type}\""
			end
			size = filters.size
			if size > 1
				filter_area = b.div(:id, "filter")
				1.upto(size-1) do |i|
					filter = filters[i]
					puts filter
					begin
						filter_area.link(:text, "#{filter}").click
					rescue
						url = "不存在的过滤条件:\"#{filter}\""
						break
					end
				end
			end
			url = b.url if url.empty?
			b.close
			url
		end
		
		#根据节目-视频url返回指定页码的全部视频ID集
		def get_video_id_arry url
			video_id_arry = Array.new
			doc = Hpricot(open(url))
			doc.search("div[@class=items]/ul").each do |ul|
				ul.search("li/a").each do |a|
					href = a.attributes["href"]
					video_id_arry << get_id_by_url(href)
					break
				end
			end
			video_id_arry
		end

		#根据url返回视频ID
		def get_id_by_url url
			if url =~ /id_z/
				get_latest_video_id url
			else
				get_id_by_video_url url
			end
		end

		#根据节目url获取最新的视频ID
		def get_latest_video_id url
			video_id = ""
			doc = Hpricot(open(url))
			doc.search("div[@class=btnplay]/a") do |a|
				href = a.attributes["href"]
				video_id = get_id_by_video_url href
			end
			video_id
		end

		#根据视频url获取对于的视频ID
		def get_id_by_video_url url
			video_id = url.scan(/id_(.*)\./)[0]
		end
	
	end
#### 定义类方法 end ####

end

