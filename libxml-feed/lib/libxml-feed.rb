begin
    require 'rubygems'
    gem 'hpricot'
rescue LoadError => e
end

require 'hpricot'
require "#{File.join(File.dirname(__FILE__), 'parser', 'base')}"

module Hpricot
    module Feed
        def self.parser(doc, klass, version)
            require "#{File.join(File.dirname(__FILE__), 'parser', klass.to_s)}"
            return Hpricot::Feed::Parser.new(doc, Hpricot::Feed::Parser.const_get(klass), version)
        end
    end
end
