require 'collamine/request'
require 'spidercrawl'

require 'curb'
require 'domainatrix'
require 'mongo'

class Collamine
  include Mongo
  STORE = MongoClient.new("localhost", 27017).db("smartcache").collection("html")

  def self.start(url, options)
    from_collamine = []
    pages = Spiderman.shoot(url, options) do |web|
      collamine = nil
      web.before_fetch do |url|
        # Try to fetch from collamine server
        puts "trying collamine: #{url}" 
        puts "fetched from collamine: #{url}" if (collamine = Request.try_collamine(url))
        from_collamine << url if collamine
        collamine
      end
      web.on_redirect do |url|
        # Try to fetch from collamine server
        puts "trying collamine: #{url}" 
        puts "fetched from collamine: #{url}" if (collamine = Request.try_collamine(url))
        from_collamine << url if collamine
        collamine
      end
      web.after_fetch do |page|
        unless page.content == ''
          # Upload to collamine if it cannot be found in server
          unless collamine
            puts "uploading to collamine: #{page.url}"
            filename = page.url.split('/').last
            filename += '.html' unless filename.include?('.html')
            Request.upload_to_collamine(page.url, page.content, filename, page.crawled_time.to_i)
          end
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
          end
        end
      end
    end
    return pages, from_collamine
  end
end
