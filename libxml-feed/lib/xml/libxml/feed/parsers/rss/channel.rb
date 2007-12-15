require 'xml/libxml/feed/parsers/rss/common'

class XML::Feed::Parser::Rss::Channel
    include XML::Feed::Parser::Rss::Common

    def item
        items = []
        @node.find('./item').each do |x|
            items.push XML::Feed::Parser::Rss::Item.new(x)
        end

        return items
    end
end
