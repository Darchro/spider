class HomeController < ApplicationController
  # require 'nokogiri'
  # require 'open-uri'

  def index
    # url = "http://weixin.sogou.com/pcindex/pc/pc_6/pc_6.html"
    # @doc = Nokogiri::HTML.parse(open(url), nil, 'utf-8')
    @articles = Article.all
  end
end
