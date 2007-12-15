require 'test/unit'
require 'xml/libxml/feed'

class TestParserInterface < Test::Unit::TestCase
    def test_validate_rss_20
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('1.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end

        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/basic.xml'), true)
        end

        # test a valid one first
        assert_nothing_raised do
            XML::Feed::Parser.rss('2.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end
        
        # test without the version
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-root-2.0-rss.xml'), true)
        end

        # test without the version
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/missing-version-2.0-rss.xml'), true)
        end
        
        # invalid version
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/invalid-version-2.0-rss.xml'), true)
        end
        
        # missing channel 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/missing-channel-2.0-rss.xml'), true)
        end
    end
end
