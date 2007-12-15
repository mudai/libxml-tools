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
                        validate_20
                    else
                        validation_error "Validating RSS version #{@version} is not supported (yet!)"
                    end

                    @validated = true
                end

                protected

                def validate_xpath(xpath, error_message, &block)
                    node = @doc.find(xpath)

                    if node and node.first
                        begin 
                            result = yield node.first.content
                        rescue Exception
                            validation_error error_message
                        end
                    end

                    validation_error error_message unless result
                end

                def validate_20
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

                    %w(link docs).each do |uri|
                        validate_xpath("/rss/channel/#{uri}", "Channel #{uri} does not parse as a URI") do |x|
                            URI.parse(x)
                        end
                    end

                    %w(pubDate lastBuildDate).each do |t|
                        validate_xpath("/rss/channel/#{t}", "Channel #{t} does not parse as a rfc822 time") do |x|
                            Time.rfc2822(x)
                        end
                    end

                    validate_xpath('/rss/channel/ttl', 'Channel ttl is not an integer') do |x|
                        x.to_i.to_s == x
                    end

                    if @doc.find('/rss/channel/cloud')
                        warn "Cloud support is currently not implemented"
                    end
                end
            end
        end
    end
end
