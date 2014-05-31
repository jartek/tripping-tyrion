require 'spec_helper'

describe Transfermarkt::Team do
  let(:national_team_url) { URI('http://transfermarkt.com/england/startseite/verein/3299') }
  let(:club_team_url) { URI('http://transfermarkt.com/jumplist/startseite/verein/31') }

  let(:national_response) do
    england = File.open(File.dirname(__FILE__) + '/assets/england.html')
    stub_request(:get, national_team_url).to_return(status: 200, body: england, headers: {})
    Transfermarkt::Team.new(national_team_url)
  end

  let(:club_response) do
    liverpool = File.open(File.dirname(__FILE__) + '/assets/liverpool.html')
    stub_request(:get, club_team_url).to_return(status: 200, body: liverpool, headers: {})
    Transfermarkt::Team.new(club_team_url)
  end

  describe '#national_team?' do
    context 'England' do
      it 'is a national_team' do
        national_team = national_response.national_team?
        expect(national_team).to eq(true)
      end
    end
    context 'Liverpool' do
      it 'is not a national_team' do
        club_team = club_response.national_team?
        expect(club_team).to eq(false)
      end
    end
  end

  describe '#squad_size' do
    context 'England' do
      it 'squad size' do
        expect(national_response.squad_size).to eq(23)
      end
    end
    context 'Liverpool' do
      it 'squad size' do
        expect(club_response.squad_size).to eq(22)
      end
    end
  end

  describe '#players' do
    context 'England' do
      let(:players) { national_response.players }
      it 'returns entire squad' do
        expect(players.length).to eq(national_response.squad_size)
      end

      it 'should have sturridge' do
        sturridge_present = players.any? { |player| player.include?('sturridge') }
        expect(sturridge_present).to eq(true)
      end

      it 'shouldn\'t have hodgson' do
        sturridge_present = players.any? { |player| player.include?('hodgson') }
        expect(sturridge_present).to eq(false)
      end
    end
  end

  describe '#manager' do
    context 'England' do
      it 'returns hodgson' do
        expect(national_response.manager).to include('hodgson')
      end
    end
    context 'Liverpool' do
      it 'returns rodgers' do
        expect(club_response.manager).to include('rodgers')
      end
    end
  end

  describe '#stadium' do
    context 'England' do
      it 'returns nil' do
        expect(national_response.stadium).to be_nil
      end
    end

    context 'Liverpool' do
      it 'returns stadium link' do
        expect(club_response.stadium).to include('stadion') #stadion = stadium in german
      end
    end
  end

  describe "#fixtures" do
    context 'England' do
      it 'returns stadium link' do
        expect(national_response.fixtures).to include('spielplan') #spielplan = fixtures in german
      end
    end
  end
end
