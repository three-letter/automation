require File.dirname(__FILE__) + "/remote_ssh.rb"

class IndexBuilder  
  include RemoteSsh
  
  #根据条件重建索引
  def self.build(*args)
    build_info = ""
    type, state, flag, ct = *args
    #索引增量更新
    if type && !type.empty?
      k, v = type.split(".")
      build_info += index_builder(k, v)
    end
    #节目字段更新
    if state
      sid, eid = state.split(/\s+/)
      if eid.nil? || eid.empty?
        eid = sid
      end
    build_info += video_makestat(sid, eid) unless sid.nil?
    end
    #视频状态更新
    build_info += video_chgvideoflag if flag.to_i == 1
    #视频分类更新
    build_info += video_sync_video_category if ct.to_i == 1
    build_info
  end
end
