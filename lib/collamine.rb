require 'collamine/request'
require 'spidercrawl'

class Collamine
  def self.start(url, options)
    Request.setup_collamine(download: options[:download], upload: options[:upload])
    from_collamine = []
    pages = Spiderman.shoot(url, options) do |web|
      collamine = nil
      web.before_fetch do |url|
        @setup.yield url unless @setup.nil?
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
        end
        @teardown.yield page, from_collamine unless @teardown.nil?
      end
    end
    return pages, from_collamine
  end

  def self.before_fetch(&block)
    @setup = block if block
  end

  def self.after_fetch(&block)
    @teardown = block if block
  end
end
