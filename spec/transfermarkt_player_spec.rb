require 'spec_helper'

describe Transfermarkt::Player do
  let(:player_url) { "http://transfermarkt.com/daniel-sturridge/profil/spieler/47082" }

  let(:player) do
    studge = File.open(File.dirname(__FILE__) + '/assets/sturridge.html')
    stub_request(:get, player_url).to_return(status: 200, body: studge, headers: {})
    Transfermarkt::Player.new(player_url)
  end


end
