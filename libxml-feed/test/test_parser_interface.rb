require 'test/unit'
require 'xml/libxml/feed'
require 'stringio'

class TestParserInterface < Test::Unit::TestCase
    def test_loader
        parser = nil
        assert_nothing_raised do 
            parser = XML::Feed::Parser.rss('2.0', "<rss></rss>", false)
        end

        assert_instance_of(XML::Feed::Parser::Rss, parser)
    end

    # tests various forms of IO that can be passed to the constructors for the default parsers
    def test_IO_acceptance
        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', '<rss></rss>', false)
        end

        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', File.open('test/data/basic.xml', 'r'), false)
        end

        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', StringIO.new("<rss></rss>"), false)
        end

        assert_raise(XML::Feed::Parser::InvalidHandle) do
            XML::Feed::Parser.rss('2.0', Array.new, false)
        end

        assert_raise(XML::Feed::Parser::InvalidHandle) do
            XML::Feed::Parser.rss('2.0', '', false)
        end
    end

    def test_base_accessors
        parser = nil

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', '<rss></rss>', false)
        end

        assert_equal('<rss></rss>', parser.xml)
        assert_equal('2.0', parser.version)

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('1.0', File.open('test/data/basic.xml', 'r'), false)
        end

        assert_equal(File.open('test/data/basic.xml').read, parser.xml)
        assert_equal('1.0', parser.version)
        
        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', StringIO.new('<rss></rss>'), false)
        end

        assert_equal('<rss></rss>', parser.xml)
        assert_equal('2.0', parser.version)
        assert(!parser.validated)

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/basic.xml', 'r'), true)
        end

        assert_equal(File.open('test/data/basic.xml').read, parser.xml)
        assert_equal('2.0', parser.version)
        assert(parser.validated)
    end
end
