require 'collamine/request'
require 'spidercrawl'

class Collamine

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
      web.after_fetch do |page|
        # Upload to collamine if it cannot be found in server
        unless collamine then 
          puts "uploading to collamine: #{page.url}"
          filename = page.url.split('/').last
          filename += '.html' unless filename.include?('.html')
          Request.upload_to_collamine(page.url, page.content, filename, page.crawled_time.to_i)
        end
      end
    end
    return pages, from_collamine
  end
end