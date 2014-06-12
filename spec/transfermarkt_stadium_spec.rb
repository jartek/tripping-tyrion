require 'spec_helper'

describe Transfermarkt::Stadium do
  let(:stadium_url) { "http://transfermarkt.com/liverpool-fc/stadion/verein/31" }

  let(:stadium) do
    anfield = File.open(File.dirname(__FILE__) + '/assets/anfield.html')
    stub_request(:get, stadium_url).to_return(status: 200, body: anfield, headers: {})
    Transfermarkt::Stadium.new(stadium_url)
  end

  describe "#name" do
    it "returns the name" do
      expect(stadium.name).to eq("Anfield")
    end
  end

  describe "#capacity" do
    it "returns the capacity" do
      expect(stadium.capacity).to eq("45276")
    end
  end

  describe "#year_built" do
    it "returns the year the stadium was built" do
      expect(stadium.year_built).to eq("1884")
    end
  end

  describe "#corporate_boxes" do
    it "returns the number of corporate boxes" do
      expect(stadium.corporate_boxes).to eq("160")
    end
  end

  describe "#turf_heating?" do
    it "returns if the stadium has turf heating" do
      expect(stadium.turf_heating?).to eq(true)
    end
  end

  describe "#running_track?" do
    it "returns if the stadium has a running track" do
      expect(stadium.running_track?).to eq(false)
    end
  end

  describe "#size" do
    it "returns the width of the pitch" do
      expect(stadium.size[:width]).to eq('101m')
    end

    it "returns the height of the pitch" do
      expect(stadium.size[:height]).to eq('68m')
    end
  end

  describe "#surface" do
    it "returns the type of surface" do
      expect(stadium.surface).to eq("Natural turf")
    end
  end

  describe "#address" do
    it "returns the address" do
      expect(stadium.address).to eq(["Anfield Road", "L4 0TH Liverpool", "England"])
    end
  end
end
