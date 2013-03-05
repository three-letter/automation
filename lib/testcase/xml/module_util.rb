#coding:utf-8
require 'rexml/document'

#module manager util
module ModuleUtil
  @@file = File.expand_path("../module.txt", __FILE__)
  @@root = File.expand_path("..", __FILE__)
  
  def read_xml file
    infos = []
    File.open(file) do |f|
      while line = f.gets
        infos << line
      end
    end
    infos.join
  end

  #获取所有的case module,其中#开头的为注释不读取 已经其对应的具体case名
  def read_modules
    modules = []
    cases = []
    File.open(@@file,"r") do |f|
      while line=f.gets
        line.strip!
        next if line.length == 0
        next if line.index("#") == 0
        modules << line
      end
    end
    modules.each do |m|
      dir_case = []
      Dir["#{@@root}/xmls/*"].each do |f|
        dir = f.match(/#{@@root}\/xmls\/#{m}_for_(.*)/)
        next if dir.nil?
        d = dir[1]
        dir_case << d
      end
      cases << dir_case
    end
    Hash[modules.zip(cases)]
  end

  #添加module
  def add_module md
    md.strip!
    return "Module不能为空！" if md.empty?
    modules = read_modules
    return "#{md}已经存在！" if modules.include?(md)
    File.open(@@file,"a") do |f|
      f.puts md
    end
    return "#{md}添加成功！"
  end

  #删除module
  def destroy_module md
    md.strip!
    return "数据不能为空！" if md.empty?
    modules = read_modules
    return "#{md}不存在！" unless modules.include?(md)
    modules.delete(md)
    File.open(@@file,"w") do |f|
      modules.each do |m|
        f.puts m
      end
    end
    system "rm -f #{@@root}/xmls/#{md}_for_*.xml"
    return "#{md}删除成功！"
  end


  ### module method action
  def add_module_method md,me
    md.strip!
    me.strip!
    return "数据不能为空！" if md.empty? || me.empty?
    direct = "#{@@root}/xmls/#{md}_for_#{me}"
    Dir.mkdir("#{direct}")
    return "#{me}添加成功！"
  end

  def destroy_module_method md,me
    md.strip!
    me.strip!
    return "数据不能为空！" if md.empty? || me.empty?
    direct = "#{md}_for_#{me}"
    system "rm -rf #{@@root}/xmls/#{direct}"
    return "#{me}删除成功！"
  end

  ## module method case action
  def read_module_method_case md,me
    md.strip!
    me.strip!
    return "数据不能为空！" if md.empty? || me.empty?
    cases = []
    direct = "#{md}_for_#{me}"
    Dir["#{@@root}/xmls/#{direct}/*"].each do |f|
      cases << File.basename(f,".xml")
    end
    cases
  end

  def add_module_method_case md,me,cs,info
    cs.strip!
    info.strip!
    return "数据不能为空！" if cs.empty? || info.empty?
    file = "#{@@root}/xmls/#{md}_for_#{me}/#{cs}.xml"
    File.open(file,"w") do |f|
      f.puts info
    end
    begin
      f = File.open(file)
		  doc = REXML::Document.new(f)
      nil
    rescue => e
      msg = e.message.to_s
      err = "XML格式不正确！"
      #puts "index: #{msg.match(/ParseException:(.+?)>/)[0]}"
      err = msg.match(/ParseException:(.+?)Line:/)[1] if msg =~ /ParseException:(.+?)Line:/
      return err
      #return "XML格式不正确！"
    end
  end


end
