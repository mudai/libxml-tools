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

    def test_output
        builder = nil

        assert_nothing_raised do
            builder = XML::Feed::Builder.rss("2.0")
        end

        assert_equal("<?xml version=\"1.0\"?>\n<rss version=\"2.0\"/>\n", builder.to_xml)

        parser = nil

        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/valid-2.0-rss.xml'), true)
        end

        assert_nothing_raised do
            builder = XML::Feed::Builder.rss("2.0", parser)
        end

        assert_equal(parser.doc.to_s, builder.to_xml)

        assert_nothing_raised do
            builder = XML::Feed::Builder.rss("2.0")
        end

        assert_nothing_raised do
            builder.channel.create do |x|
                x.items.create do |y|
                    y.title = "Bar"
                    y.description = "Foo"
                    y.link = URI.parse("http://funky.cold.medina.com")
                end
            end
        end

        assert_equal(
            "<?xml version=\"1.0\"?>\n<rss version=\"2.0\">\n  <channel>\n    <item>\n      <title>Bar</title>\n      <description>Foo</description>\n      <link>http://funky.cold.medina.com</link>\n    </item>\n  </channel>\n</rss>\n",
             builder.to_xml
        )

        assert_nothing_raised do
            builder = XML::Feed::Builder.rss("2.0", parser)
        end

        assert_nothing_raised do
            builder.channel[0].items.create do |y|
                y.title = "Bar"
                y.description = "Foo"
                y.link = URI.parse("http://funky.cold.medina.com")
            end
        end

        assert_equal(File.open("test/data/valid-2.0-rss-build1.xml").read.gsub(/\r/, ''), builder.to_xml)
        
        assert_nothing_raised do
            parser = XML::Feed::Parser.rss('2.0', File.open('test/data/valid-2.0-rss.xml'), true)
            builder = XML::Feed::Builder.rss("2.0", parser)
        end

        assert_nothing_raised do
            builder.channel[0].items.create do |y|
                y.title = "Bar"
                y.description = "Foo"
                y.link = URI.parse("http://funky.cold.medina.com")
                y.category = "my_category"
                y.category[0]["domain"] = "alt.swedish.chef.bork.bork.bork"
            end
        end

        assert_equal(File.open("test/data/valid-2.0-rss-build2.xml").read.gsub(/\r/, ''), builder.to_xml)
    end
end
