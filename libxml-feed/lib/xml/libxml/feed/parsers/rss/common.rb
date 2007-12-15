module XML::Feed::Parser::Rss::Common
    attr_reader :node

    def initialize(node)
        @node = node
    end

    def method_missing(methId, *args)
    end
end
