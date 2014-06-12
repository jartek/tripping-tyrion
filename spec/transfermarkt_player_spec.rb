require 'spec_helper'

describe Transfermarkt::Player do
  let(:player_url) { "http://transfermarkt.com/daniel-sturridge/profil/spieler/47082" }

  let(:player) do
    studge = File.open(File.dirname(__FILE__) + '/assets/sturridge.html')
    stub_request(:get, player_url).to_return(status: 200, body: studge, headers: {})
    Transfermarkt::Player.new(player_url)
  end

  describe "#date_of_birth" do
    it "returns the date of birth" do
      expect(player.date_of_birth).to eq(Date.new(1989,9,1))
    end
  end

  describe "#full_name" do
    it "returns the player's full name" do
      expect(player.full_name).to eq("Daniel Andre Sturridge")
    end
  end

  describe "#birthplace" do
    it "returns the player's birthplace" do
      expect(player.birthplace).to eq("Birmingham")
    end
  end

  describe "#height" do
    it "returns the player's height" do
      expect(player.height).to eq("1,83 m")
    end
  end

  describe "#foot" do
    it "returns the player's foot" do
      expect(player.foot).to eq("left")
    end
  end

  describe "#main_nationality" do
    it "returns the player's main nationality" do
      expect(player.main_nationality).to eq("England")
    end
  end

  describe "#secondary_nationality" do
    it "returns the player's secondary nationality" do
      expect(player.secondary_nationality).to eq("Jamaica")
    end
  end

  describe "#current_club" do
    it "returns the player's current club" do
      expect(player.current_club).to eq("Liverpool FC")
    end
  end

  describe "#main_position" do
    it "returns the player's main position" do
      expect(player.main_position).to eq("Centre Forward")
    end
  end

  describe "#secondary_positions" do
    it "returns the player's secondary position" do
      expect(player.secondary_positions).to eq(["Right Wing", "Left Wing"])
    end
  end

  describe "#transfer_history" do
    it "returns the date of transfer" do
      expect(player.transfer_history[0]['date']).to eq(Date.new(2013,1,2))
    end

    it "returns the previous club" do
      expect(player.transfer_history[0]['from']).to eq("Chelsea FC")
    end

    it "returns the new club" do
      expect(player.transfer_history[0]['to']).to eq("Liverpool FC")
    end

    it "returns the cost of transfer" do
      expect(player.transfer_history[0]['cost']).to eq("15,00 Mill. €")
    end
  end
end
