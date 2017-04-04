require 'identifiers/doi'

RSpec.describe Identifiers::DOI do
  it 'extracts DOIs from a string' do
    str = 'This is an example of DOI: 10.1049/el.2013.3006'

    expect(described_class.extract(str)).to contain_exactly('10.1049/el.2013.3006')
  end

  it 'extracts DOIs from any where in a string' do
    str = 'This is an example of DOI - 10.1049/el.2013.3006 - which is entirely valid'

    expect(described_class.extract(str)).to contain_exactly('10.1049/el.2013.3006')
  end

  it 'downcase the DOIs extracted' do
    str = 'This is an example of DOI: 10.1097/01.ASW.0000443266.17665.19'

    expect(described_class.extract(str)).to contain_exactly('10.1097/01.asw.0000443266.17665.19')
  end

  it 'does not extract a PubMed ID' do
    str = 'This is NOT a DOI: 123456'

    expect(described_class.extract(str)).to be_empty
  end

  it 'extracts ISBN-As' do
    str = 'This is an ISBN-A: 10.978.8898392/315'

    expect(described_class.extract(str)).to contain_exactly('10.978.8898392/315')
  end

  it 'does not extract invalid ISBN-As' do
    str = 'This is not an ISBN-A: 10.978.8898392/NotARealIsbnA'

    expect(described_class.extract(str)).to be_empty
  end

  it 'retains potentially valid trailing punctuation' do
    str = 'This is an example of DOI: 10.1130/2013.2502(04)'

    expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502(04)')
  end
end
