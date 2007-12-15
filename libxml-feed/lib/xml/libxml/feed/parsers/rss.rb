require 'stringio'

module XML
    module Feed
        module Parser
            class Rss < XML::Feed::Parser::Base
                def initialize(version, io, auto_validate=true)
                    super
                end

                def validate!
                    @validated = true
                end
            end
        end
    end
end
