#coding:utf-8
require File.expand_path("../../../lib/testcase/xml/test_case_xml.rb", __FILE__)

class TestApiController < ApplicationController
  layout "testapi" 

## the view for testcase

  def index
    @modules = TestCaseXml.read_modules
  end
  
  def method
    @md = params[:md]
    @me = params[:me]
    path = File.expand_path("../../..", __FILE__)
    file = "#{path}/lib/testcase/xml/example.xml"
    @example = TestCaseXml.read_xml file
    @modules = TestCaseXml.read_modules
    @cases = TestCaseXml.read_module_method_case(@md,@me)
  end

  def case
    @md = params[:md]
    @me = params[:me]
    @ca = params[:ca]
    @modules = TestCaseXml.read_modules
    path = File.expand_path("../../..", __FILE__)
    file = "#{path}/lib/testcase/xml/xmls/#{@md}_for_#{@me}/#{@ca.strip}.xml"
    @case_content = TestCaseXml.read_xml(file)
    render action: "case"
  end

  def test
    @modules = TestCaseXml.read_modules
    @md = params[:md]
    @me = params[:me]
    choose_cases = params[:choose_case]
  unless choose_cases
      @cases = TestCaseXml.read_module_method_case(@md,@me)
      flash[:notice] = "请选择testcase！"
      render action: "method", me: @me, md: @md
  else
    case_paths = []
    path = File.expand_path("../../..", __FILE__)
    # 初始化待测试用例(即case xml文件)路径
    choose_cases.each do |c|
      case_paths << "#{path}/lib/testcase/xml/xmls/#{@md}_for_#{@me}/#{c.strip}.xml"
    end
    # 根据测试用例xml返回每个xml的运行结果(以case为单位)
    @expects = []
    @facts = []
    catch(:start){
    case_paths.each_with_index do |f,i|
      TestCaseXml.init_xml f
      expect_hash = Hash.new
      expect = []
      fact = []
      case_array = TestCaseXml.get_test_case
      case_array.each do |c|
        ep_hash = Hash.new
        desc = c["desc"]
        # get expect result
        ep = TestCaseXml.get_expect c
        ep_hash[desc] = ep
        expect << ep_hash
        # get real result
        fa_hash = Hash.new
        url = c["url"]
        fa = TestCaseXml.get_fact c
        if fa.include?("该JSON中")
          @cases = TestCaseXml.read_module_method_case(@md,@me)
          flash[:notice] = fa
          render action: "method", me: @me, md: @md
          throw :start
        end
        fa_hash[url] = fa
        fact << fa_hash
      end
      expect_hash[choose_cases[i]] = expect
      @expects << expect_hash
      @facts << fact
    end
    render action: "test"
    }
  end
end

## the operation for modul, method, case 

  def add_module
    md = params[:module]
    flash[:notice] = TestCaseXml.add_module(md)
    redirect_to action: "index"
  end
  
  def destroy_module
    md = params[:module]
    flash[:notice] = TestCaseXml.destroy_module(md)
    redirect_to action: "index"
  end


  def add_module_method
    md = params[:module_name]
    me = params[:module_method]
    flash[:notice] = TestCaseXml.add_module_method(md,me)
    redirect_to action: "index"
  end

  def destroy_module_method
    md = params[:module_name]
    me = params[:module_method]
    flash[:notice] = TestCaseXml.destroy_module_method(md,me)
    redirect_to action: "index"
  end

  def add_module_method_case
    md = params[:module_name]
    me = params[:module_method]
    cs = params[:case_name]
    info = params[:case_info]
    flash[:notice] = TestCaseXml.add_module_method_case(md,me,cs,info)
    redirect_to action: "method", md:md, me:me
  end

end
