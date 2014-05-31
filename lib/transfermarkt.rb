require 'open-uri'
require 'nokogiri'

module Transfermarkt
  class Team
    attr_reader :data

    BASE_DOMAIN = 'http://transfermarkt.com'

    def initialize(url)
      @data = Nokogiri::HTML(get(url))
    end

    def national_team?
      data.css('.profilheader tr').any? { |row| row.text.include?('Placement FIFA world ranking') }
    end

    def squad_size
      data.css('.profilheader tr').select { |row| row.text.include?('Squad size') }[0].css('td').text.strip.to_i
    end

    def players
      player_array = data.css('.items').first.css('tr.odd, tr.even').css('.inline-table tr:first-child td:last-child a')
      player_array.inject([]) do |collection, player|
        collection << BASE_DOMAIN + player['href']
      end
    end

    def manager
      staff_container = data.css('.header_slider').select { |row| row.css('p.text').text.strip == 'Staff' }[0].parent
      manager = staff_container.css('li.slider-list').select { |row| row.css('.container-zusatzinfo b:first-child').text.strip == 'Manager' }[0]
      BASE_DOMAIN + manager.css('.container-hauptinfo a')[0]['href']
    end

    def stadium
      return if national_team?
      BASE_DOMAIN + data.css('.profilheader a[href*=stadion]')[0]['href']
    end

    def fixtures
      BASE_DOMAIN + data.css('.footer a[href*=spielplan]')[0]['href']
    end

    private
    def get url
      open(url).read
    end
  end

  class Player
  end

  class Stadium
  end
end
