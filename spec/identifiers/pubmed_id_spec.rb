require 'identifiers/pubmed_id'

RSpec.describe Identifiers::PubmedId do
  it 'extracts PubMed IDs' do
    expect(described_class.extract("123\n456")).to contain_exactly('123', '456')
  end

  it 'does not return outputs with PubMed IDs in DOIs' do
    str = "10.1038/nplants.2015.3\n10.1126/science.286.5445.1679e"

    expect(described_class.extract(str)).to be_empty
  end

  it 'strips leading 0s' do
    expect(described_class.extract("0000010203\n000456000")).to contain_exactly('10203', '456000')
  end

  it 'does not consider 0 as a valid Pubmed ID' do
    expect(described_class.extract("00000000")).to be_empty
  end

  it 'extracts PubMed IDs separated by Unicode whitespace' do
    expect(described_class.extract('123 456')).to contain_exactly('123', '456')
  end

  it 'considers Fixnum as potential PubmedIds too' do
    expect(described_class.extract(123)).to contain_exactly('123')
  end
end
