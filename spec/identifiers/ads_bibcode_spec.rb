require 'identifiers/ads_bibcode'

RSpec.describe Identifiers::AdsBibcode do
  describe '#extract' do
    it 'does extract a bibcode' do
      str = 'This is a Bibcode: 1974AJ.....79..819H'

      expect(described_class.extract(str)).to contain_exactly('1974AJ.....79..819H')
    end

    it 'does extract a PhD Thesis Bibcode' do
      expect(described_class.extract('2004PhRvL..93o0801M')).to contain_exactly('2004PhRvL..93o0801M')
    end

    it 'does not extract Bibcodes from DOIs' do
      expect(described_class.extract('10.1097/01.ASW.0000443266.17665.19')).to be_empty
    end
  end
end
