require 'open-uri'
require 'nokogiri'

module Transfermarkt
  BASE_DOMAIN = 'http://transfermarkt.com'

  def get(url)
    open(url).read
  end

  class Team
    include Transfermarkt

    attr_reader :data

    def initialize(url)
      @data = Nokogiri::HTML(get(url))
    end

    def national_team?
      data.css('.profilheader tr').any? { |row| row.text.include?('Placement FIFA world ranking') }
    end

    def squad_size
      data.css('.profilheader tr').select { |row| row.text.include?('Squad size') }[0].css('td').text.strip.gsub("\u00A0", "").to_i
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
  end

  class Player
    include Transfermarkt

    attr_reader :data

    def initialize(url)
      @data = Nokogiri::HTML(get(url))
    end

    def full_name
      data.css('.auflistung:first tr').select { |row| row.text.include?('Name in home country') }[0].css('td').text.strip.gsub("\u00A0", "")
    end

    def date_of_birth
      Date.parse(data.css('.auflistung:first tr').select { |row| row.text.include?('Date of birth') }[0].css('td').text.strip.gsub("\u00A0", ""))
    end

    def birthplace
      data.css('.auflistung:first tr').select { |row| row.text.include?('Place of birth') }[0].css('td').text.strip.gsub("\u00A0", "")
    end

    def height
      data.css('.auflistung:first tr').select { |row| row.text.include?('Height') }[0].css('td').text.strip.gsub("\u00A0", "")
    end

    def foot
      data.css('.auflistung:first tr').select { |row| row.text.include?('Foot') }[0].css('td').text.strip.gsub("\u00A0", "")
    end

    def main_nationality
      data.css('.auflistung:first tr').select { |row| row.text.include?('Nationality') }[0].css('td img:first')[0]['title'].strip.gsub("\u00A0", "")
    end

    def secondary_nationality
      data.css('.auflistung:first tr').select { |row| row.text.include?('Nationality') }[0].css('td img:last')[0]['title'].strip.gsub("\u00A0", "")
    end

    def current_club
      data.css('.profilheader tr').select { |row| row.text.include?('Current club') }[0].css('td').text.strip.gsub("\u00A0", "")
    end

    def main_position
      data.css('.auflistung:nth-child(1) tr').select { |row| row.text.include?('Main position') }[0].css('td').text.split(":").last.strip.gsub("\u00A0", "")
    end

    def secondary_positions
      data.css('.auflistung:nth-child(1) tr').select { |row| row.text.include?('Secondary positions') }[0].css('td a').collect { |a| a.text.strip.gsub("\u00A0", "") }
    end

  end

  class Stadium
  end
end
