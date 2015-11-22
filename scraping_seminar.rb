require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'

robotex = Robotex.new
p robotex.allowed?("https://www.goodfind.jp/2016/seminar/")

db = SQLite3::Database.new('scraping.db')
db.execute('CREATE TABLE IF NOT EXISTS seminars (title varchar(100), sub_title varchar(200));')

url = "https://www.goodfind.jp/2016/seminar/"
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

doc.css("#toggle_view_section > div.toggle.list_view > div > div > ul > li > a > div.seminar_desc").each do |title|
  puts title.css("h3").text
  puts title.css("p").text
  db.execute 'INSERT INTO seminars values ( ?, ? );', ["#{title.css("h3").text}", "#{title.css("p").text}"]
end
