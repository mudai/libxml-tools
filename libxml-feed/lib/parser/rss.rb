module Hpricot    
    module Feed
        class Parser
            module RSS
                class RSS2
                    def _item_base
                        '/rss/channel/item'
                    end
                end

                def self.provides
                    {
                        "2.0" => Hpricot::Feed::Parser::RSS::RSS2
                    }
                end
            end
        end
    end
end
