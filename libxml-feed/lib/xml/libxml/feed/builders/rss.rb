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
