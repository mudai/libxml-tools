module XML::Feed::Parser::Rss::Common
    attr_reader :node

    def initialize(node)
        @node = node
    end

    def method_missing(methId, *args)
        requested = node.find("./#{methId.to_s}")
        if requested.first
            if requested.length > 1
                array = []
                requested.each do |x|
                    array.push type_node(x)
                end

                return array
            else
                return type_node(requested.first)
            end
        end

        return nil
    end
    protected

    def type_node(node)
        case node.name
        when 'pubDate'
            Time.rfc2822(node.content)
        when 'lastBuildDate'
            Time.rfc2822(node.content)
        when 'docs'
            URI.parse(node.content)
        when 'link'
            URI.parse(node.content)
        when 'url'
            URI.parse(node.content)
        when 'ttl'
            node.content.to_i
        else
            node.content
        end
    end
end
