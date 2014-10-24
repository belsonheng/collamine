require 'cgi'
require 'net/http/post/multipart'

module Collamine
  # Makes the request to CollaMine servers
  class Request

  	#
  	# Try downloading the content from CollaMine servers
  	#
  	def try_collamine(url)
	  uri = URI.parse(COLLAMINE_DOWNLOAD_URL+CGI::escape(url.to_s))
	  Net::HTTP.start(uri.host, uri.port) do |http|
	    response = http.get(uri)
	    case response
	      when Net::HTTPSuccess then
	          return nil if response.body == 'not found' rescue nil
	          return response.body 
	      else nil
	    end
	  end
	end

	#
	# Upload the content to Collamine servers
	#
	def upload_to_collamine(url, content, filename)
	  post_request = Net::HTTP::Post::Multipart.new  COLLAMINE_UPLOAD_URL,
	  										'domain'		=> URI.parse(url).host,
	  										'url' 			=> url,
	  										'crawltime'		=> 0,
	  										'contributor'  	=> 'belson',
	  	  									'document'     	=> UploadIO.new(StringIO.new(content.encode('UTF-8', 'ISO-8859-15')), 'text/html', filename)                                 
	  response = Net::HTTP.start(URI.parse(COLLAMINE_UPLOAD_URL).host, URI.parse(COLLAMINE_UPLOAD_URL).port) { |http| http.request(post_request) }
	  puts response.body
	end
  end
end
