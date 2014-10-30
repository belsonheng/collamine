require 'collamine'
require 'domainatrix'
require 'mongo'

pages, from_collamine = Collamine.start('http://forums.hardwarezone.com.sg/hwm-magazine-publication-38/', 
	                                    :parallel => true,
	                                    :threads => 30,
                                        :pattern => Regexp.new('^http:\/\/forums\.hardwarezone\.com\.sg\/hwm-magazine-publication-38\/?(.*\.html)?$'))


puts "### Start inserting crawled resutls to database..."
#Save results to mongodb
include Mongo
db = MongoClient.new("localhost", 27017).db("smartcache")
store = db.collection("html")

pages.sort_by! { |page| page.url }

pages.each do |page| 
  puts page.url
  source = (from_collamine.include?(page.url) ? 'collamine' : 'original')
  doc = {"url" => page.url, 
         "domain" => Domainatrix.parse(page.url).domain,
         "source" => source, 
         "content" => page.content.encode('UTF-8', 'ISO-8859-15'), 
         "crawled_date" =>  page.crawled_time.to_i,
         "response_time" => page.response_time.to_i
        }
  id = store.insert(doc)
end
puts "Total pages: #{pages.size}"
puts "done"