module XML
    module Feed
        module Parser
            def self.method_missing(method, *args)
                require "xml/libxml/feed/parsers/#{method.to_s.downcase}"
                return self.const_get(method.to_s.capitalize).new(*args)
            end
        end
    end
end
