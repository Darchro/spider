require 'nokogiri'
require 'open-uri'

namespace :article do
  desc "get article from http://werank.cn/"
  task get_articles: :environment do
    url = "http://werank.cn/"
    doc = Nokogiri::HTML.parse(open(url), nil, 'utf-8')
    doc.search('div .row .col-md-10').each do |ele|
      category_title = ele.element_children.text
      category = Category.find_or_create_by!(title: category_title)
      ele.parent.next_element.search('tbody tr').each do |tr|
        account = Account.find_or_create_by!(name: tr.element_children[0].content)
        next if Article.where(account_id: account.id, title: tr.element_children[1].content).exists?
        article = account.articles.new(
          category_id: category.id, 
          title: tr.element_children[1].content,
          cnt_comment: tr.element_children[5].content,
          cnt_admiration: tr.element_children[6].content
          )
        article_link = tr.element_children[1].search('a')[0]['href']
        puts article_link
        article_show_doc = Nokogiri::HTML.parse(open(article_link), nil, 'utf-8')
        article_show_doc.search('.inline_editor_value .StatsRow').each do |article_ele|
          puts article_ele.element_children[1].text
        end
      end
      break
    end
  end

end
