require 'stringio'

module XML
    module Feed
        module Parser
            class Rss < XML::Feed::Parser::Base
                def initialize(version, io, auto_parse=true)
                    super
                end

                def parse
                    return XML::Feed::Parser::AST.new
                end
            end
        end
    end
end
