require File.dirname(__FILE__) + '/index_builder.rb'

class IndexTest
  msg = IndexBuilder.build("5",'',3)
  puts msg
end
