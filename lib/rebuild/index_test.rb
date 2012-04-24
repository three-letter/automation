require File.dirname(__FILE__) + '/index_builder.rb'

class IndexTest
  msg = IndexBuilder.build("4",'')
  puts msg
end
