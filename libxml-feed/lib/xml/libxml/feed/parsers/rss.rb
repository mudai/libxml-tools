require 'stringio'

module XML
    module Feed
        module Parser
            class Rss < XML::Feed::Parser::Base
                def initialize(version, io, auto_validate=true)
                    super
                end

                def validate!
                    case @version
                    when '2.0'
                        validation_error "Document Root is not named 'rss'"    unless @doc.root.name.downcase == "rss"
                        validation_error "Document Version does not exist"     unless @doc.root["version"]
                        validation_error "Document Version is not '2.0'"       unless @doc.root["version"] == "2.0"
                        validation_error "Channel elements do not exist"       if @doc.find('/rss/channel').length == 0

                        @doc.find('/rss/channel').each_with_index do |node, i|
                            %w(title link description).each do |x|
                                validation_error "Channel node #{i} does not have a #{x} element"   unless node.find('./' + x).length > 0
                                validation_error "Channel node #{i} has more than one #{x} element" if node.find('./' + x).length > 1
                            end
                        end

                        # check that link is a URI
                        node = @doc.find('/rss/channel/link').first

                        begin
                            URI.parse(node.content)
                        rescue Exception
                            validation_error "Channel link does not parse"
                        end

                        # parse the pubdate
                        node = @doc.find('/rss/channel/pubDate')

                        if node and node.first
                            begin
                                t = Time.rfc2822(node.first.content)
                            rescue Exception
                                validation_error "Channel PubDate does not parse"
                            end
                        end

                    else
                        validation_error "Validating RSS version #{@version} is not supported (yet!)"
                    end

                    @validated = true
                end
            end
        end
    end
end
