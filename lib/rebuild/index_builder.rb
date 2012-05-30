require File.dirname(__FILE__) + "/remote_ssh.rb"

class IndexBuilder  
  include RemoteSsh
  
  def self.build(*args)
    index_builder(*args)
  end
end
