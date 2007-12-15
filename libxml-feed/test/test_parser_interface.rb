require 'test/unit'
require 'xml/libxml/feed'
require 'stringio'

class TestParserInterface < Test::Unit::TestCase
    def test_loader
        parser = nil
        assert_nothing_raised do 
            parser = XML::Feed::Parser.rss('2.0', "", false)
        end

        assert_instance_of(XML::Feed::Parser::Rss, parser)
    end

    # tests various forms of IO that can be passed to the constructors for the default parsers
    def test_IO_acceptance
        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', '', false)
        end

        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', File.open('/dev/null', 'r'), false)
        end

        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', StringIO.new(""), false)
        end

        assert_raise(XML::Feed::Parser::InvalidHandle) do
            XML::Feed::Parser.rss('2.0', Array.new, false)
        end
    end

    def test_base_accessors
        parser = nil

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', 'asdf', false)
        end

        assert_equal(parser.xml, 'asdf')
        assert_equal(parser.version, '2.0')

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('1.0', File.open('test/data/cruft', 'r'), false)
        end

        assert_equal(parser.xml, "this is cruft\n")
        assert_equal(parser.version, '1.0')
        
        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', StringIO.new('asdf'), false)
        end

        assert_equal(parser.xml, 'asdf')
        assert_equal(parser.version, '2.0')
        assert(!parser.parsed)

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/basic.xml', 'r'), true)
        end

        assert(parser.parsed)
        assert(parser.ast)
        assert_kind_of(XML::Feed::Parser::AST, parser.ast)
    end
end
