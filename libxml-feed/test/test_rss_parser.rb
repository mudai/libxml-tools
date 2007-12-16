require 'test/unit'
require 'xml/libxml/feed'

class TestValidation < Test::Unit::TestCase

    def test_rss_interface
        parser = nil

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end
        
        assert(parser.channel)
        assert_kind_of(Array, parser.channel)
        assert_kind_of(XML::Feed::Parser::Rss::Channel, parser.channel[0])

        assert(parser.channel[0].pubDate)
        assert_kind_of(XML::Feed::Parser::Tag, parser.channel[0].pubDate)
        assert_kind_of(Time, parser.channel[0].pubDate.data)
        assert_kind_of(Hash, parser.channel[0].pubDate.property)

        assert(parser.channel[0].lastBuildDate)
        assert_kind_of(XML::Feed::Parser::Tag, parser.channel[0].lastBuildDate)
        assert_kind_of(Time, parser.channel[0].lastBuildDate.data)
        assert_kind_of(Hash, parser.channel[0].lastBuildDate.property)

        assert(parser.channel[0].link)
        assert_kind_of(XML::Feed::Parser::Tag, parser.channel[0].link)
        assert_kind_of(URI, parser.channel[0].link.data)
        assert_kind_of(Hash, parser.channel[0].link.property)

        assert(parser.channel[0].docs)
        assert_kind_of(XML::Feed::Parser::Tag, parser.channel[0].docs)
        assert_kind_of(URI, parser.channel[0].docs.data)
        assert_kind_of(Hash, parser.channel[0].docs.property)

        assert(parser.channel[0].ttl)
        assert_kind_of(XML::Feed::Parser::Tag, parser.channel[0].ttl)
        assert_kind_of(Numeric, parser.channel[0].ttl.data)
        assert_kind_of(Hash, parser.channel[0].ttl.property)

        assert(parser.channel[0].item)
        assert_kind_of(Array, parser.channel[0].item)

        parser.channel[0].item.each do |item|
            assert_kind_of(XML::Feed::Parser::Rss::Item, item)
            if item.link
                assert_kind_of(XML::Feed::Parser::Tag, item.link)
                assert_kind_of(URI, item.link.data)
                assert_kind_of(Hash, item.link.property)
            end
            if item.description
                assert_kind_of(XML::Feed::Parser::Tag, item.description)
                assert_kind_of(String, item.description.data)
                assert_kind_of(Hash, item.description.property)
            end
            if item.title
                assert_kind_of(XML::Feed::Parser::Tag, item.title)
                assert_kind_of(String, item.title.data)
                assert_kind_of(Hash, item.title.property)
            end
        end
    end

    def test_validate_rss
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('1.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end
    end

    def test_validate_rss_20
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
        
        # missing channel title
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/missing-channel-title-2.0-rss.xml'), true)
        end
        
        # missing channel link 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/missing-channel-link-2.0-rss.xml'), true)
        end
        
        # missing channel description 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/missing-channel-description-2.0-rss.xml'), true)
        end

        # duplicate channel title 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/duplicate-channel-title-2.0-rss.xml'), true)
        end

        # duplicate channel link 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/duplicate-channel-link-2.0-rss.xml'), true)
        end
        
        # duplicate channel description 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/duplicate-channel-description-2.0-rss.xml'), true)
        end
        
        # bad URI
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-uri-2.0-rss.xml'), true)
        end
        
        # bad pubDate
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-pubdate-2.0-rss.xml'), true)
        end
        
        # bad ttl
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-ttl-2.0-rss.xml'), true)
        end

        # bad image 
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-image-2.0-rss.xml'), true)
        end
       
        # bad item
        assert_raise(XML::Feed::Parser::ValidationError) do
            XML::Feed::Parser.rss('2.0', File.open('test/data/bad-item-2.0-rss.xml'), true)
        end
    end
end
