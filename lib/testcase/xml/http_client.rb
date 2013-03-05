require 'net/http'

# http clint操作，用于发送get post数据并返回response
module HttpClient
  # 发送get请求
  def get url
    url = URI.parse url
    doc = Net::HTTP.get url
  end

  # 发送post请求
  def post url, params
    url = URI.parse url
    response = Net::HTTP.post_form(url, params)
    response.body
  end

end
