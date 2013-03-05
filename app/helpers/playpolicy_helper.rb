#coding:utf-8

module PlaypolicyHelper
  #根据conf显示param的匹配情况
  def show_match_info conf, match_info
    conf = escape_javascript conf
    conf = conf.gsub("\\n","<br/>")
    info = conf
    match_info.each do |match|
      info = info.gsub(/([\s,;])#{match}([,;])/,"#{$1}<font color='red'>#{match}</font>#{$2}")
    end
    info.html_safe 
  end

  #根据fact expect显示测试结果信息
  def show_test_result fact, expect
    result = ""
    if fact == -1
      result = "<font color='orange'>异常</font>"  
    else
      result = fact == expect ? "<font color='green'>通过</font>" : "<font color='red'>失败</font>"
    end
    result.html_safe
  end

end

