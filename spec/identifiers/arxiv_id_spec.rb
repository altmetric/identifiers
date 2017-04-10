require 'identifiers/arxiv_id'

RSpec.describe Identifiers::ArxivId do
  describe '#extract' do
    it 'does extract a pre 2007 arXiv ID' do
      expect(described_class.extract('Example: math.GT/0309136')).to contain_exactly('math.GT/0309136')
    end

    it 'does extract a post 2007 unversioned arXiv ID' do
      expect(described_class.extract('Example: arXiv:0706.0001')).to contain_exactly('0706.0001')
    end

    it 'does extract a post 2007 versioned arXiv ID' do
      expect(described_class.extract('Example: arXiv:1501.00001v2')).to contain_exactly('1501.00001v2')
    end

    it 'does not extract IDs from DOIs that end in a valid arXiv ID' do
      expect(described_class.extract('10.1049/el.2013.3006')).to be_empty
    end

    it 'does not extract IDs from DOIs that contain a valid arXiv ID' do
      expect(described_class.extract('10.2310/7290.2014.00033')).to be_empty
    end

    it 'extracts a post 2007 arXiv ID surrounded by Unicode whitespace' do
      expect(described_class.extract('Example: arXiv:0706.0001 ')).to contain_exactly('0706.0001')
    end

    it 'extracts a pre 2007 arXiv ID surrounded by Unicode whitespace' do
      expect(described_class.extract('Example: math.GT/0309136 ')).to contain_exactly('math.GT/0309136')
    end
  end
end
