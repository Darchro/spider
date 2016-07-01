require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'

namespace :wxb do
  desc "TODO"
  task get_articles: :environment do
    # Specify the driver path
    chromedriver_path = "/Users/zjf/chrome_downloads/chromedriver"
    puts chromedriver_path
    Selenium::WebDriver::Chrome.driver_path = chromedriver_path

    # Start the browser as normal
    b = Watir::Browser.new :chrome
    b.goto 'http://www.wxb.com/follow/rank'
    b.text_field(name: 'email').set("17721016972")
    b.text_field(name: 'password').set("zoujinfu1990")
    b.button(class: 'btn btn-primary js-login-btn').click

    Watir::Wait.until {b.text.include? '316178'}

    category_tabs = b.lis :class => 'follow-article-rank-tab'

    category_tabs.each_with_index do |tab, index|
      i = 0
      begin
        tab.click
        sleep 3
        3.times do
          begin
            b.div(class: 'load-more none-visibility js-loadMore').when_present.click
            sleep 3
          rescue => e
            puts "click load more button error: #{e}"
            i += 1
            if i <= 3
              retry
            end
          end
        end

        category = Category.find_or_create_by!(title: tab.text)
        begin
          table = b.tables(:class => 'my-follow-article-all-table').last
          table.rows.each do |row|
            next unless row.tds.length > 0
            puts row.tds[0].link.href
            account = Account.find_or_create_by!(name: row.tds[1].text)
            next if Article.where(account_id: account.id, title: row.tds[0].text).exists?
            category.articles.create(account: account,
              title: row.tds[0].text, 
              cnt_read: row.tds[2].text, 
              cnt_like: row.tds[3].text,
              link: row.tds[0].link.href
              )
          end
        rescue => e
          puts "find articles error: #{e}"
          retry
        end
      rescue => e
        puts "click category tab error: #{e}"
        retry
      end
    end
    b.close
  end

end
