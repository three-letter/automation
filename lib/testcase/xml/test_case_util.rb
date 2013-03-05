#coding:utf-8
require File.expand_path("../../../json/json_util", __FILE__)
require File.expand_path("../http_client", __FILE__)
require 'mysql2'

# 根据测试用例，比较用例的预期结果和实际结果
# 返回改用例的测试结果信息
module TestCaseUtil
  include HttpClient
  
## 解析testcase,获取预期值
  def get_expect testcase
    type = testcase["result"]["type"]
    self.send("get_#{type}_expect".to_sym, testcase)
  end



  # the expect value for Constant type
  def get_constant_expect testcase
    testcase["result"]["value"]
  end

  # the expect value for Db type
  def get_db_expect testcase
    db = testcase["result"]["source"]
    sql = testcase["result"]["value"]
    con = get_default_db_connection db
    rst = []
    field = sql.match(/select(.+?)from/)[1].strip      
    con.query(sql).each do |r|
      rst << r["#{field}"]
    end
    rst
  end

  # the expect value for page type
  def get_page_expect testcase
    url = testcase["result"]["source"]
    regx = testcase["result"]["value"]
    doc = get(url)
    rst = ""
    if doc =~ /#{regx}/
      rst = doc.match(/#{regx}/)[1]
    end
    rst
  end

## 获取testcase实际值
  def get_fact testcase
    url = testcase["url"]
    key = testcase["fact"] 
    keys = []
    keys << key
    rst = JsonUtil.get_results(keys,url)
    rst = rst.is_a?(String) ? rst : rst.join
    rst = rst.gsub("=>",":")
  end




#### 根据不同的db source返回对应的数据库连接
  def get_db_connection db
    get_default_db_connection db
  end

  #默认的数据库连接 12
  def get_default_db_connection db
    Mysql2::Client.new(:host => "10.10.221.12", :username => "root", :password => "yhnji-db-yoqoo", :database => "#{db}")   
  end

end

=begin
tcu = TestCaseUtil.new
#cases = {"result" => {"type" => "constant", "source" => "ref", "value" => 123} }
cases = {"result" => {"type" => "db", "source" => "od", "value" => "select pk_odshow from t_odshow limit 1"} }
#cases = {"result" => {"type" => "page", "source" => "http://www.baidu.com", "value" => "<p id=\"lg\">(.+?)</p>"} }
tcu.get_expect cases
=end
