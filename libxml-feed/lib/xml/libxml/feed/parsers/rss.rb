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

                def validate_xpath(node, xpath, error_message, &block)
                    node = node.find(xpath)

                    result = true

                    if node and node.first
                        begin 
                            result = yield node.first.content
                        rescue Exception => e
                            validation_error error_message
                        end
                    end

                    validation_error error_message unless result
                end

                # all the validation rules for RSS 2.0 that are fit to print.
                def validate_20
                    validation_error "Document Root is not named 'rss'" unless @doc.root.name.downcase == "rss"
                    validation_error "Document Version does not exist"  unless @doc.root["version"]
                    validation_error "Document Version is not '2.0'"    unless @doc.root["version"] == "2.0"
                    validation_error "Channel elements do not exist"    if     @doc.find('/rss/channel').length == 0

                    @doc.find('/rss/channel').each_with_index do |node, i|

                        validate_20_channel(node, i)

                        if items = node.find('./item')
                            items.each_with_index do |item, item_i|
                                validation_error "Item must contain a title or description" unless item.find('./title').first or item.find('./description').first
                                validate_xpath(item, './pubDate', "Channel #{i} item #{item_i} element pubDate does not parse as a rfc822 time") do |x|
                                    Time.rfc2822(x)
                                end
                                validate_xpath(item, './link', "Channel #{i} item #{item_i} element link does not parse as a URI") do |x|
                                    URI.parse(x)
                                end
                            end
                        end
                    end
                end

                def validate_20_channel(node, i)
                    %w(title link description).each do |x|
                        validation_error "Channel node #{i} does not have a #{x} element"   unless node.find('./' + x).length > 0
                        validation_error "Channel node #{i} has more than one #{x} element" if node.find('./' + x).length > 1
                    end
                    %w(link docs).each do |uri|
                        validate_xpath(node, "./#{uri}", "Channel #{i} element #{uri} does not parse as a URI") do |x|
                            URI.parse(x)
                        end
                    end
                    %w(pubDate lastBuildDate).each do |t|
                        validate_xpath(node, "./#{t}", "Channel #{i} element #{t} does not parse as a rfc822 time") do |x|
                            Time.rfc2822(x)
                        end
                    end
                    validate_xpath(node, './ttl', 'Channel #{i} element ttl is not an integer') do |x|
                        x.to_i.to_s == x
                    end
                    if node.find('./cloud')
                        warn "Cloud support is currently not implemented"
                    end
                    if image = node.find('./image')
                        %w(url link).each do |ele|
                            validate_xpath(node, "./image/#{ele}", "Channel #{i} element image/#{ele} does not parse as a URI") do |x|
                                URI.parse(x)
                            end
                        end
                        validation_error "Title element must exist in Channel #{i} element image" unless node.find('./title').length > 0
                    end
                end
            end
        end
    end
end
