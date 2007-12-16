require 'test/unit'
require 'xml/libxml/feed'
require 'stringio'

class TestBuilderInterface < Test::Unit::TestCase

    def test_loader
        builder = nil
        assert_nothing_raised do
            builder = XML::Feed::Builder.rss('2.0')
        end

        assert_instance_of(XML::Feed::Builder::Rss, builder)

        # test with a parser
        parser = nil
        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end

        assert_instance_of(XML::Feed::Parser::Rss, parser)

        assert_nothing_raised do
            builder = XML::Feed::Builder.rss('2.0', parser)
        end

        assert_instance_of(XML::Feed::Builder::Rss, builder)
    end
end
