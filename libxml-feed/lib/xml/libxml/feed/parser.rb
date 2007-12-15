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
                attr_reader :ast
                attr_reader :parsed

                def initialize(version, io, auto_parse=true)
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

                    if auto_parse
                        @parsed = true
                        @ast    = parse
                        @ast.freeze
                    else
                        @parsed = false
                        @ast    = nil
                    end
                end
            end

            class AST
                
                class TypeError < Exception
                end

                attr_reader :name
                attr_reader :arguments
                attr_reader :attributes

                def initialize(symbol_name)
                    @name = symbol_name
                    @arguments = Array.new
                    @attributes = Hash.new
                end

                def set_attribute(key, value)
                    if key.kind_of? String and value.respond_to? :to_s
                        @attributes[key] = value
                    else
                        raise TypeError, "Both key and value must be string. Value must at least be able to coerce into string."
                    end
                end

                def add_ast(ast)
                    if ast.kind_of? self.class
                        @arguments.push ast
                    else
                        raise TypeError, "Must be an AST type to continue"
                    end
                end

                def inspect
                    return "<AST #{@name}: [arguments: #{@arguments.collect { |x| x.inspect }.join(" : ")}] - [ attributes: #{@attributes.collect { |key, value| "#{key}:#{value}" }.join("/")}]>"
                end
            end
        end
    end
end
