require 'collamine'
require 'mongo'
require 'domainatrix'

#http://forums.hardwarezone.com.sg/hwm-magazine-publication-38/
#http://forums.hardwarezone.com.sg/money-mind-210/
#http://sgforums.com/forums/4
#http://forums.vr-zone.com/photography-lightroom/
#http://forums.gumi.sg/forum/news-boards
#http://en.forums.wordpress.com/
#http://www.spcnet.tv/forums/showthread.php/38762-Dugu-Jiu-Jian-Really-Unbeatable
#http://www.hungrygowhere.com/
#http://www.groupon.sg/
#http://www.amazon.com/
#https://www.apple.com/sg/
#http://forums.hardwarezone.com.sg/current-affairs-lounge-17/

include Mongo
STORE = MongoClient.new("localhost", 27017).db("smartcache").collection("html")

Collamine.before_fetch do |url|
  puts "Do what you want to the url: #{url}"
end

Collamine.after_fetch do |page, from_collamine|
  # Check if duplicate
  unless STORE.find("url" => page.url).to_a.size > 0
    # Insert into Mongodb
    puts "Insert to db: #{page.url}"
    source = (from_collamine.include?(page.url) ? 'collamine' : 'original')
    doc = {:url => page.url, 
           :domain => Domainatrix.parse(page.url).domain,
           :source => source, 
           :content => page.content.encode('UTF-8', 'ISO-8859-15'), 
           :crawled_date =>  page.crawled_time.to_i,
           :response_time => page.response_time.to_i
    }
    STORE.insert(doc)
  else
    puts "url exists"
  end
end

pages, from_collamine = Collamine.start('http://forums.hardwarezone.com.sg/money-mind-210/',
	                                :pattern => Regexp.new('^http:\/\/forums\.hardwarezone\.com\.sg\/money-mind-210\/?(.*\.html)?$'),
	                                :download => 'http://172.20.131.150:9001/download/html/',
	                                :upload => 'http://172.20.131.150:9001/upload/html/multipart/',
                                        :parallel => true, :threads => 10)

puts "Total pages crawled: #{pages.size}"

open('/tmp/ruby.log', 'w') do |f|
  pages.each do |page|
    f << "#{page.url}\n"
  end
  f << "Total pages crawled: #{pages.size}"
end
