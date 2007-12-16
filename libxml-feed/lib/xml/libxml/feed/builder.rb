module XML
    module Feed
        module Builder
            def self.method_missing(method, *args)
                require "xml/libxml/feed/builders/#{method.to_s.downcase}"
                return self.const_get(method.to_s.capitalize).new(*args)
            end
        end
    end
end
