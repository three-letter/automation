require File.dirname(__FILE__) + "/remote_ssh.rb"

class IndexBuilder  
  include RemoteSsh
  
  def self.build(type,id)
    type = type.to_i
    case type
      when 0
        nil
      when 1
        add_video_build(id)
      when 2
        add_episode_to_video_build(id)
      when 3
        block_episode_build
      when 4
        edit_person_build
      else
        "Unknow operate type!!" 
    end
  end
  
end
