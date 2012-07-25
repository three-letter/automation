#coding:utf-8
require File.expand_path("../../../lib/rebuild/index_builder", __FILE__)
class Rebuild
  # 索引重建选择条件的封装
  # type:节目 视频[节目 DVD 今日 本月 热点 CMS 用户] 人物等 
  # state:更新节目字段 需要节目ID(起始)
  # flag:更新视频状态
  # category:更新视频分类

  attr_accessor :type, :state, :flag, :category

  def init(*args)
    @type, @state, @flag, @category = *args
  end

  def type_list
    @type_list = {"" => "","节目" => "show.show","视频" => "video.show","人物" => "person.person",
                  "CMS" => "cms.cms", "CMS部分和专辑" => "cmsdsop.cmsdsop", 
                  "节目系列" => "showseries.showseries", "看吧" => "bar.bar", 
                  "看吧帖子" => "subject.subject", "授权记录" => "ctauth.ctauth",
                  "颁奖" => "prize.prize"
                 }
  end

  # 检查输入的数据是否有效，目前只判断节目初始id是否为数字
  # 有效返回空字符则，否则返回提示信息
  def check_validate
    if self.state
      return "" if self.state.empty?
      start_show_id, end_show_id = self.state.split(/\s+/)
      if start_show_id.to_i == 0 || (!end_show_id.nil? && end_show_id.to_i == 0)
        return "节目ID不符合规范!"
      else
        return ""
      end
    end
    return ""
  end
  # 根据不同类型重建对应的索引
  def rebuild_index
    IndexBuilder.build(self.type, self.state, self.flag, self.category)
  end

end
