module Hpricot    
    module Feed
        class Parser

            attr_reader :doc
            attr_reader :xmlparser

            def initialize(doc, klass, version)
                @klass = klass
                @version = version
                @parser = klass.provides[version].new
                @doc = doc
            end

            def to_s
                return @doc.to_s
            end

            def method_missing(methId, *args)
                name = methId.id2name

                xpath = nil
                eq    = nil

                if name =~ /=$/
                    eq = true
                    name.sub!(/=$/, '')
                end

                if @parser.methods.include? name 
                    xpath = @parser.method(name).call
                end

                if xpath
                    nodes = parse(xpath)
                else
                    xpath = "/" + name
                    nodes = parse(xpath)
                end

                if eq
                    nodes.each do |x|
                        x.innerHTML = args[0]
                    end
                end

                return self.class.new(nodes, @klass, @version) 
            end

            def [](num)
                return self.class.new(@doc[num], @klass, @version)
            end

            def create(type, content="")
                @doc.innerHTML = "<#{type.to_s}>#{content}</#{type.to_s}>" + @doc.innerHTML
            end

            def parse(xpath)
                @doc.search(xpath)
            end

            def each
                @doc.each do |node|
                    yield self.class.new(node, @klass, @version)
                end
            end

            def each_entry
                xpath = @parser._item_base

                if xpath
                    parse(xpath).each do |node|
                        yield self.class.new(node, @klass, @version)
                    end
                end
            end
        end
    end
end
