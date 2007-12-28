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
            return Channel.new(@doc, @doc.root.find('/rss/channel').to_a[x])
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
            return Item.new(@channel, @channel.find('./item').to_a[x])
        end
    end

    class Item
        attr_reader :channel
        attr_reader :node

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
                my_meth = meth.sub(/=$/, '')

                node = XML::Node.new(my_meth)
                node.content = args[0].to_s
                @node << node
                return node
            end

            # if we're reading, we want to collect each node that matches our method name.
            # the problem is, XML::XPath::Object#find doesn't work on detached nodes, which ours
            # is at this state. So we have to search manually.
           
            array = []    

            @node.each do |x|
                if x.name == meth 
                    array.push x
                end
            end

            return array
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
