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
end
