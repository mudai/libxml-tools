require 'stringio'

module XML
    module Feed
        module Parser
            class Rss
                def initialize(version, io, auto_parse=true)
                    @version = version
                    case io
                    when IO
                    when StringIO
                    when String
                    else
                        raise XML::Feed::Parser::InvalidHandle, "Must be IO, StringIO, or String object"
                    end
                end
            end
        end
    end
end
