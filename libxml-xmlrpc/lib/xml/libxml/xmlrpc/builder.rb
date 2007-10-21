module XML
    module XMLRPC
        module Builder
            def self.call(methodname, *args)
                methodname = methodname.to_s

                output = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"
                output += "<methodCall><methodName>#{methodname}</methodName>"
                output += Value.generate(*args)
                output += "</methodCall>"

                return output
            end

            def self.response(*args)
                output = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"
                output += "<methodResponse>"
                output += Value.generate(*args)
                output += "</methodResponse>"

            end

            def self.fault_response(faultCode, faultMessage)
                output = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"
                output += "<methodResponse>"
                output += "<fault><value><struct>"
                output += "<member><name>faultCode</name><value>#{faultCode}</value></member>"
                output += "<member><name>faultString</name><value>#{faultMessage}</value></member>"
                output += "</struct></value></fault>"
                output += "</methodResponse>"
            end

            def self.method_missing(*args)
                self.call(*args)
            end
        end

        class Builder::Error < Exception
        end

        module Builder::Value

            def self.generate(*args)
                output = "<params>"
                args.each do |x|
                    output += "<param>"
                    output += self.generate_value(x)
                    output += "</param>"
                end
                output += "</params>"

                return output
            end

            def self.generate_value(arg)
                output = "<value>"

                # try the superclass if the class doesn't work (this isn't
                # perfect but is better than nothing)
                if const_get(arg.class.to_s).respond_to? :generate
                    output += const_get(arg.class.to_s).generate(arg)
                elsif const_get(arg.class.superclass.to_s).respond_to? :generate
                    output += const_get(arg.class.superclass.to_s).generate(arg)
                else
                    raise Builder::Error, "Type '#{arg.class}' is not supported by XML-RPC"
                end

                output += "</value>"

                return output
            end

            module Fixnum
                def self.generate(arg)
                    "<int>#{arg}</int>"
                end
            end

            module String
                def self.generate(arg)
                    "<string>#{arg}</string>"
                end
            end

            module Float
                def self.generate(arg)
                    "<double>#{arg}</double>"
                end
            end

            module Date
                def self.generate(arg)
                    "<dateTime.iso8601>" + arg.strftime("%Y%m%dT%T") + "</dateTime.iso8601>"
                end
            end

            module Array
                def self.generate(args)
                    output = "<array><data>"
                    args.each do |x|
                        output += Builder::Value.generate_value(x)
                    end
                    output += "</data></array>"

                    return output
                end
            end

            module Hash
                def self.generate(args)
                    output = "<struct>"
                    args.each_key do |key|
                        output += "<member>"
                        output += "<name>#{key}</name>"
                        output += Builder::Value.generate_value(args[key])
                        output += "</member>"
                    end
                    return output
                end
            end

            module TrueClass
                def self.generate(arg)
                    "<boolean>1</boolean>"
                end
            end

            module FalseClass
                def self.generate(arg)
                    "<boolean>0</boolean>"
                end
            end

            module NilClass
                def self.generate(arg)
                    # nil is treated as false in our spec
                    FalseClass.generate(arg)
                end
            end
        end
    end
end

if __FILE__ == $0
    require 'date'
    puts XML::XMLRPC::Builder.response([1,2,3])
end
