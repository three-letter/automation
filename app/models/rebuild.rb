#coding:utf-8
class Rebuild
  # 索引重建选择条件的封装
  # type:节目 视频[节目 DVD 今日 本月 热点 CMS 用户] 人物等 
  # state:更新节目字段 需要节目ID(起始)
  # flag:更新视频状态
  # category:更新视频分类

  attr_accessor :type, :state, :flag, :category, :type_list

  def initialize
    @type_list = {"" => "","节目" => "show.show","视频" => "video.show","人物" => "person.person",
                  "CMS" => "cms.cms", "CMS部分和专辑" => "cmsdsop.cmsdsop", 
                  "节目系列" => "showseries.showseries", "看吧" => "bar.bar", 
                  "看吧帖子" => "subject.subject", "授权记录" => "ctauth.ctauth"   
                 }
  end

  # 检查输入的数据是否有效，目前只判断节目初始id是否为数字
  # 有效返回空字符则，否则返回提示信息
  def check_validate
    if self.state && !self.state.empty?
      start_show_id, end_show_id = self.state.split(/\s+/)
      if start_show_id.to_i == 0 || end_show_id.to_i == 0
        return "节目ID不符合规范!"
      else
        return ""
      end
    end
    return ""
  end
  # 根据不同类型重建对应的索引
  def rebuild_index
    *args = self.type.split(",")
    IndexBuilder(*args)
  end

end
