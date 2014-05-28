require 'spec_helper'

describe Transfermarkt::Team do
  let(:url) { URI("http://transfermarkt.com/england/startseite/verein/3299") }
  let(:response) { Transfermarkt::Team.fetch(url) }

end
