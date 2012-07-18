require File.expand_path("../layer",__FILE__)

module JsonUtil
  extend Layer
  #根据参数key返回对应value结果
  def get_results keys, url
    doc = open(url).read
    json = JSON doc
    results = []
    keys.each do |k|
      layers = get_layer(k,url)
      children_json = json
      layers.each do |l|
        children_json = children_json["#{l}"]
      end
      results << children_json.to_s
    end
    results
  end

end

