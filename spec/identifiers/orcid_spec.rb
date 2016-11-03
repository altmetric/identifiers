require 'identifiers/orcid'

RSpec.describe Identifiers::ORCID do
  describe '.extract' do
    it 'extracts ORCIDs from a string' do
      str = "orcid.org/0000-0002-0088-0058\n0000-0002-0488-8591"

      expect(described_class.extract(str)).to contain_exactly('0000-0002-0088-0058', '0000-0002-0488-8591')
    end

    it 'normalizes the ORCID extracted' do
      str = 'orcid.org/0000-0003-0166-248x'

      expect(described_class.extract(str)).to contain_exactly('0000-0003-0166-248X')
    end
  end

  describe '.valid?' do
    it 'returns true if the ORCID is valid' do
      str = '0000-0002-0088-0058'

      expect(described_class.valid?(str)).to eq(true)
    end

    it 'returns false if the ORCID is not valid' do
      str = '0000-0002-0088-005X'

      expect(described_class.valid?(str)).to eq(false)
    end
  end

  describe '.calculate_digit' do
    it 'calculates the digit of an ORCID' do
      str = '0000-0002-0088-0058'

      expect(described_class.calculate_digit(str)).to eq('8')
    end
  end
end
