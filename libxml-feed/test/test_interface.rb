require 'test/unit'
require 'xml/libxml/feed'

class TestParserInterface < Test::Unit::TestCase
    def test_loader
        parser = nil
        assert_nothing_raised do 
            parser = XML::Feed::Parser.rss('2.0', "")
        end

        assert_instance_of(XML::Feed::Parser::Rss, parser)
    end

    # tests various forms of IO that can be passed to the constructors for the default parsers
    def test_IO_acceptance
    end
end
