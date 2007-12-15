module XML
    module Feed
        module Parser
            def self.method_missing(method, *args)
                require "xml/libxml/feed/parsers/#{method.to_s.downcase}"
                return self.const_get(method.to_s.capitalize).new(*args)
            end

            class InvalidHandle < Exception
            end

            class Base 
                attr_reader :xml
                attr_reader :version

                def initialize(version, io, auto_parse)
                    @version = version

                    case io
                    when IO
                        @xml = io.read
                        io.close
                    when StringIO
                        @xml = io.read
                        io.close
                    when String
                        @xml = io.dup
                    else
                        raise XML::Feed::Parser::InvalidHandle, "Must be IO, StringIO, or String object"
                    end

                    @xml.freeze
                    @version.freeze
                end
            end
        end
    end
end
