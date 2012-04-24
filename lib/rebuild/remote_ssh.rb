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
    #新建节目
    def add_video_build(id)
      build_info = ''
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.show.conf show_show --rotate")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.video.conf video_show --rotate")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php chgvideoflag.php -debug")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php makestat.php -i " + id + " "+ id )
      end
      build_info
    end

    #节目中添加正片
    def add_episode_to_video_build(id)
      build_info = ''
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.show.conf show_show --rotate")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.video.conf video_show --rotate")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php chgvideoflag.php -debug")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php makestat.php -i " + id + " "+ id )
      end
      build_info
    end
    
    #屏蔽正片
    def block_episode_build
      build_info = ''
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.show.conf show_show --rotate")
        build_info += ssh.exec!("cd /opt/indexbuilder/code/fd/builder/show && php chgvideoflag.php -debug")
      end
      build_info
    end

    #编辑(添加)人物信息
    def edit_person_build
      build_info = ''
      Net::SSH.start("10.10.221.107", "root", :password => "s9sv5nx8naky", :port => 22022) do |ssh|
        build_info = ssh.exec!("cd /opt/indexbuilder/code/fd/nodes && indexer -c builder.person.conf person_person --rotate")
      end
      build_info
    end
    #modul methods end
  end
  #the class method of modul end
end

