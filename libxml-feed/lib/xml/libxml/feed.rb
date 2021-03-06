begin
    require 'rubygems'
    gem 'libxml-ruby'
rescue LoadError => e
end

require 'xml/libxml'
require 'xml/libxml/feed/parser'
require 'xml/libxml/feed/builder'

module XML
    module Feed
        VERSION = "0.0.1"
    end
end
