module XML
    module Feed
        module Parser
            def self.method_missing(method, *args)
                require "xml/libxml/feed/parsers/#{method.to_s.downcase}"
                return self.const_get(method.to_s.capitalize).new(*args)
            end

            class InvalidHandle < Exception
            end

            class ValidationError < Exception
            end
            
            class Tag
                attr_reader :property
                attr_reader :data

                def initialize(name, data, properties)
                    if properties
                        @property = properties.to_h.dup 
                    else
                        @property = { }
                    end

                    if data
                        @data = data
                    else
                        @data = ""
                    end

                    @name = name.dup
                end

                def to_s
                    @data.to_s
                end

                alias to_str to_s
            end

            class Base 
                attr_reader :xml
                attr_reader :version
                attr_reader :validated
                attr_reader :doc

                def initialize(version, io, auto_validate=true)
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
                    @validated = false

                    if @xml.length == 0
                        raise XML::Feed::Parser::InvalidHandle, "Resulting XML String must have a length greater than 0"
                    end

                    @doc = XML::Parser.string(@xml).parse

                    if auto_validate 
                        validate!
                    end
                end

                protected 

                def validation_error(error_string)
                    raise ValidationError, error_string
                end
            end
        end
    end
end
