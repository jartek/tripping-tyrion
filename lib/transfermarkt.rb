require "open-uri"
module Transfermarkt
  class Team
    def self.fetch url
      new.fetch url
    end

    def fetch url
      get url
    end

    private

    def get url
      open(url).read
    end
  end

  class Player
  end
end
