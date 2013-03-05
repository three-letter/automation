require File.expand_path("../case_xml_util", __FILE__)
require File.expand_path("../module_util", __FILE__)
require File.expand_path("../test_case_util", __FILE__)

class TestCaseXml
  extend CaseXmlUtil
  extend ModuleUtil
  extend TestCaseUtil
end

