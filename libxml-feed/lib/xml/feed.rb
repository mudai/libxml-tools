begin
    require 'rubygems'
    gem 'libxml-ruby'
rescue LoadError => e
end

require 'xml/libxml'

module XML::Feed
    VERSION = "0.0.1"
end
