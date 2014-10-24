require "spidercrawl"
require "collamine/request"

class Collamine

  pages = Spiderman.shoot('http://forums.hardwarezone.com.sg/hwm-magazine-publication-38/') do |web|
    web.before_spider_crawl do |url|
  	  # Check collamine
  	  Request.try_collamine(url)
    end
    web.after_spider_crawl do |url|
  	  # Upload collamine
    end
  end

  pages.each do |page| 
	#puts "#{page.url}"
	#puts "Words #{page.words}"
  end
end
