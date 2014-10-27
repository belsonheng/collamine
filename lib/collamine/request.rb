require 'cgi'
require 'net/http/post/multipart'

# Makes the request to CollaMine servers
class Request
  COLLAMINE_DOWNLOAD_URL = 'http://127.0.0.1:9001/download/html/'
  COLLAMINE_UPLOAD_URL	 = 'http://127.0.0.1:9001/upload/html/multipart/'
  #
  # Try downloading the content from CollaMine servers
  #
  def self.try_collamine(url)
    uri = URI.parse(COLLAMINE_DOWNLOAD_URL+CGI::escape(url.to_s))
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
    post_request = Net::HTTP::Post::Multipart.new COLLAMINE_UPLOAD_URL,
                                                  'domain'      => URI.parse(url).host,
                                                  'url'         => url,
                                                  'crawltime'   => crawltime,
                                                  'contributor' => 'belson',
                                                  'document'    => UploadIO.new(StringIO.new(content.encode('UTF-8', 'ISO-8859-15')), 'text/html', filename)                                 
    response = Net::HTTP.start(URI.parse(COLLAMINE_UPLOAD_URL).host, URI.parse(COLLAMINE_UPLOAD_URL).port) { |http| http.request(post_request) }
    puts response.body
  end
end
