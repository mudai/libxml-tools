class XML::Feed::Builder::Rss
    class Channels
        include Enumerable

        attr_reader :doc

        def initialize(doc)
            @doc = doc
        end

        def create
            node = Channel.new(@doc)
            yield node 
            @doc.root << node.node
        end

        def each
            @doc.root.find('/rss/channel').each do |x|
                yield Channel.new(@doc, x)
            end
        end

        def [](x)
            return Channel.new(@doc, @doc.root.find('/rss/channel')[x])
        end
    end

    class Channel
        attr_reader :doc
        attr_reader :node

        def initialize(doc, node=nil)
            @doc = doc
            @node = node
            @node = XML::Node.new("channel") unless @node
        end

        def items
            return Items.new(@doc, @node)
        end
    end

    class Items
        include Enumerable

        def initialize(doc, channel)
            @doc = doc
            @channel = channel
        end

        def create
            node = Item.new(@channel)
            yield node
            @channel << node.node
        end

        def each
            @channel.find('./item').each do |x|
                yield Item.new(@channel, x)
            end
        end

        def [](x)
            return Item.new(@channel, @channel.find('./item')[x])
        end
    end

    class Item
        attr_reader :channel

        def initialize(channel, node=nil)
            @channel = channel
            @node    = node

            @node = XML::Node.new('item') unless @node
            @params = Hash.new
        end

        # basic parameters that just get enclosed by a <tag>. More involved
        # stuff should create it's own pair of methods.
        def method_missing(method, *args)
            meth = method.to_s 
            if meth =~ /=$/ # assignment
                @params[meth.sub(/=$/, '')] = args[0]
            else
                @params[meth] = args[0]
            end
        end

        def node
            # unwind params and attach them to the node
            @params.each do |key, value|
                node = XML::Node.new(key)
                node.content = value.to_s
                @node << node
            end

            return @node
        end
    end
end

class XML::Feed::Builder::Rss

    attr_accessor :version
    attr_accessor :doc

    def initialize(version, parser=nil)
        @version = version
        @parser  = parser

        build_document
    end

    def to_xml
        @doc.to_s
    end

    def channel
        return Channels.new(@doc)
    end

    protected

    def build_document
        if @parser
            @doc = @parser.doc
        else
            @doc = XML::Document.new
            @doc.root = XML::Node.new("rss")
        end

        @doc.root["version"] = @version
    end
end
