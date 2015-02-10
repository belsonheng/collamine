require 'collamine'
require 'domainatrix'
require 'mongo'

pages, from_collamine = Collamine.start('http://forums.hardwarezone.com.sg/hwm-magazine-publication-38/', 
	                                     :parallel => true,
	                                     :threads => 30,
                                       :pattern => Regexp.new('^http:\/\/forums\.hardwarezone\.com\.sg\/hwm-magazine-publication-38\/?(.*\.html)?$'))
