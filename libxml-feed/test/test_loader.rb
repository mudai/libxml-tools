require 'test/unit'
require 'xml/libxml/feed'

class TestLoader < Test::Unit::TestCase
    def test_loader
        parser = nil
        assert_nothing_raised do 
            parser = XML::Feed::Parser.rss('2.0')
        end

        assert_instance_of(XML::Feed::Parser::Rss, parser)
    end
end
