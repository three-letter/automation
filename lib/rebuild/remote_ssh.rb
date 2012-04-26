#coding: utf-8
require 'rubygems'
require 'net/ssh'

module RemoteSsh
  
  def self.included(base)
    base.class_eval do 
      extend IndexBuild
    end
  end
  
  #索引重构
  module IndexBuild
    #新建节目 根据不同的操作范围执行对应的脚本 并返回直接结果
    def add_video_build(id,area)
      build_info = ""
      case area
        when 1 #只更新索引增量信息
          build_info += index_show_show
          build_info += index_video_show
        when 2 #只更新节目需同步的信息
          build_info += video_makestat(id)
          build_info += video_chgvideoflag
        when 3 #节目信息和索引增量全部更新
          build_info += index_show_show
          build_info += index_video_show
          build_info += video_makestat(id)
          build_info += video_chgvideoflag
      end
      build_info
    end

    #节目中添加正片 根据不同的操作范围执行对应的脚本 并返回直接结果
    def add_episode_to_video_build(id,area)
      build_info = ""
      case area
        when 1 #只更新索引增量信息
          build_info += index_show_show
          build_info += index_video_show
        when 2 #只更新节目需同步的信息
          build_info += video_makestat(id)
          build_info += video_chgvideoflag
        when 3 #节目信息和索引增量全部更新
          build_info += index_show_show
          build_info += index_video_show
          build_info += video_makestat(id)
          build_info += video_chgvideoflag
      end
      build_info
    end

    #屏蔽正片 根据不同的操作范围执行对应的脚本 并返回直接结果
    def block_episode_build(area)
      build_info = ""
      case area
        when 1 #只更新索引增量信息
          build_info += index_show_show
        when 2 #只更新节目需同步的信息
          build_info += video_chgvideoflag
        when 3 #节目信息和索引增量全部更新
          build_info += index_show_show
          build_info += video_chgvideoflag
      end
      build_info
    end

    #编辑(添加)人物信息 根据不同的操作范围执行对应的脚本 并返回直接结果
    def edit_person_build(area)
      build_info = ""
      case area
        when 1 #只更新索引增量信息
          build_info += index_person_person
        when 2 #只更新节目需同步的信息
          build_info += "该范围内无需任何操作!"
        when 3 #节目信息和索引增量全部更新
          build_info += index_person_person
      end
      build_info
    end
############# 所有的关联脚本,分为2大类:节目信息同步 索引增量同步
##节目信息同步的所有关联脚本 video_*
    
    #更新节目需异步更新的字段数据
    def video_makestat(id) 
      build_info = ""
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php makestat.php -i " + id + " "+ id )
      end
      build_info
    end

    #更新节目的状态
    def video_chgvideoflag
      build_info = ""
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php chgvideoflag.php -debug")
      end
      build_info
    end
    
####索引增量同步的所有关联脚本 index_*
    
    #更新show_show索引
    def index_show_show
      build_info = ""
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.show.conf show_show --rotate")
      end
      build_info
    end

    #更新视频显示索引video_show
    def index_video_show
      build_info = ""
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.video.conf video_show --rotate")
      end
      build_info
    end
    
    #更新人物索引person_person
    def index_person_person
      build_info = ""
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.person.conf person_person --rotate")
      end
      build_info
    end
######## modul methods end ##########

#### 方法测试集合

    #测试多命令操作
    def test_command(area)
      build_info = ''
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && ls")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && ls")
      end
      build_info
    end
    #测试方法组合调用
    def test_method_add(area)
      puts test_command(area)
    end

  end
  #the class method of modul end
end

