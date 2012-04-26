require File.dirname(__FILE__) + "/remote_ssh.rb"

class IndexBuilder  
  include RemoteSsh
  
  def self.build(type,id,area)
    type = type.to_i
    area = area.to_i
    case type
      when 0
        nil
      when 1
        add_video_build(id,area)
      when 2
        add_episode_to_video_build(id,area)
      when 3
        block_episode_build(area)
      when 4
        edit_person_build(area)
      else
        test_method_add(area)
    end
  end
  
end
