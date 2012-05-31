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
    @@host = "10.10.221.101"
    @@user = "root"
    @@pwd  = "XHCeH34bEVBs"
    @@port = 22022

    #新建节目 根据不同的操作范围执行对应的脚本 并返回直接结果


############# 所有的关联脚本,分为2大类:节目信息同步 索引增量同步
##节目信息同步的所有关联脚本 video_*
    
    #更新节目需异步更新的字段数据
    def video_makestat(id, eid) 
      build_info = ""
      Net::SSH.start(@@host, @@user, :password => @@pwd, :port => @@port) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php makestat.php -i " + id + " "+ eid )
      end
      build_info
    end

    #更新节目的状态
    def video_chgvideoflag
      build_info = ""
      Net::SSH.start(@@host, @@user, :password => @@pwd, :port => @@port) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php chgvideoflag.php -debug")
      end
      build_info
    end
    
    #更新视频分类
    def video_sync_video_category
      build_info = ""
      Net::SSH.start(@@host, @@user, :password => @@pwd, :port => @@port) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/builder/video && php sync_video_category.php")
      end
      build_info
    end

####索引增量同步的所有关联脚本
    
    def index_builder(*args)
      build_info = ""
      Net::SSH.start(@@host, @@user, :password => @@pwd, :port => @@port) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.#{args[0]}.conf #{args[0]}_#{args[1]} --rotate")
      end
      build_info
    end
  
  end
  #the class method of modul end
end

