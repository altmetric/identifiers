require 'identifiers/pubmed_id'

RSpec.describe Identifiers::PubmedId do
  it 'extracts PubMed IDs' do
    expect(described_class.extract("123\n456")).to contain_exactly('123', '456')
  end

  it 'does not return outputs with PubMed IDs in DOIs' do
    str = "10.1038/nplants.2015.3\n10.1126/science.286.5445.1679e"

    expect(described_class.extract(str)).to be_empty
  end
end
