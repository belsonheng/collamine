require 'cgi'
require 'net/http/post/multipart'
require 'domainatrix'

# Makes the request to CollaMine servers
class Request
  def self.setup_collamine(options)
    @collamine_download_url = options[:download]
    @collamine_upload_url = options[:upload]
  end
  #
  # Try downloading the content from CollaMine servers
  #
  def self.try_collamine(url)
    uri = URI.parse(@collamine_download_url+CGI::escape(url.to_s))
    Net::HTTP.start(uri.host, uri.port) do |http|
      response = http.get(uri)
      case response
      when Net::HTTPSuccess then
        return nil if response.body == 'not found' rescue nil
        return response
      else nil
      end
    end
  end
  #
  # Upload the content to Collamine servers
  #
  def self.upload_to_collamine(url, content, filename, crawltime)
    post_request = Net::HTTP::Post::Multipart.new @collamine_upload_url,
                                                  'domain'      => Domainatrix.parse(url).domain,
                                                  'url'         => url,
                                                  'crawltime'   => crawltime,
                                                  'contributor' => 'belson',
                                                  'document'    => UploadIO.new(StringIO.new(content.encode('UTF-8', 'ISO-8859-15')), 'text/html', filename)                                 
    response = Net::HTTP.start(URI.parse(@collamine_upload_url).host, URI.parse(@collamine_upload_url).port) { |http| http.request(post_request) }
    puts response.body
  end
end
