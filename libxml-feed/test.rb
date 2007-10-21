require 'lib/libxml-feed'

p = Hpricot::XML(File.open('foo.rss'))
f = Hpricot::Feed.parser(p, :RSS, '2.0')

f.rss.channel.title = "Test"

f.rss.channel.item.each do |x|
    x.description = "Blah"
end

f.rss.channel.create :item
f.rss.channel.item[0].create :title, "Foo"

puts f
