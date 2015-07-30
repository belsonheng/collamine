require 'collamine'

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

pages, from_collamine = Collamine.start('http://forums.hardwarezone.com.sg/money-mind-210/',
                                       :parallel => true,
                                       :threads => 10, 
                                       :pattern => Regexp.new('^http:\/\/forums\.hardwarezone\.com\.sg\/money-mind-210\/?(.*\.html)?$'))

puts "Total pages crawled: #{pages.size}"

open('/tmp/ruby.log', 'w') do |f|
  pages.each do |page|
    f << "#{page.url}\n"
  end
  f << "Total pages crawled: #{pages.size}"
end
