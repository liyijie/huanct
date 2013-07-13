class Comment < ActiveRecord::Base
  attr_accessible :dianping, :gongxian, :last_time, :member, :name, :qiandao, :reg_time

  # 分页显示的默认值
  self.per_page = 10
  
  def self.create_by_member member
    comment = Comment.new
    comment.member = member
    url = "http://www.dianping.com/member/#{member}"

    params = {
      :headers => {
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"
      }
    }
    response = HTTParty.get(url, params)
    # puts response.body

    nodes = Nokogiri::XML(response.body).xpath("//h2")
    nodes.each do |node|
      text = node.get_attribute "class"
      next if text.nil?
      if (text == "name")
        comment.name = node.text
      end
    end
    
    nodes = Nokogiri::XML(response.body).xpath("//a")
    nodes.each do |node|
      text = node.text
      next if text.nil?
      if (text.start_with? "点评(")
        comment.dianping = text.sub("点评(","").sub(")","")
      elsif (text.start_with? "签到(")
        comment.qiandao = text.sub("签到(","").sub(")","")
      end
    end

    nodes = Nokogiri::XML(response.body).xpath("//span")
    nodes.each do |node|
      text = node.get_attribute "title"
      if text
        if (text.start_with? "贡献值")
          comment.gongxian = text.sub("贡献值","")
        end
      elsif (node.text.start_with? "注册时间")
          comment.reg_time = node.parent.text.sub("注册时间：","")
      elsif (node.text.start_with? "最后登录")
          comment.last_time = node.parent.text.sub("最后登录：","")
      end
    end
    comment
  end

  def merge other
    @member = other.member
    @name = other.name
    @dianping = other.dianping
    @gongxian = other.gongxian
    @qiandao = other.qiandao
    @reg_time = other.reg_time
    @last_time = other.last_time
  end
end
