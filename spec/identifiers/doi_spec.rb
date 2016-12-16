require 'identifiers/doi'

RSpec.describe Identifiers::DOI do
  it 'extracts DOIs from a string' do
    str = 'This is an example of DOI: 10.1049/el.2013.3006 and here is some content after it'

    expect(described_class.extract(str)).to contain_exactly('10.1049/el.2013.3006')
  end

  it 'extracts multiple DOIs from a string' do
    str = 'This is an example of DOI: 10.1049/el.2013.3006 and here is a second one: 10.1016/0041-0101(94)90134-1'

    expect(described_class.extract(str)).to contain_exactly('10.1049/el.2013.3006', '10.1016/0041-0101(94)90134-1')
  end

  it 'downcase the DOIs extracted' do
    str = 'This is an example of DOI: 10.1097/01.ASW.0000443266.17665.19'

    expect(described_class.extract(str)).to contain_exactly('10.1097/01.asw.0000443266.17665.19')
  end

  it 'avoids DOIs which look surprisingly like DOIs, but are not' do
    str = 'This is an example of an invalid DOI: 10.111/j.1746-692x.2008.00078.x'

    expect(described_class.extract(str)).to be_empty
  end

  it 'does not extract a PUBMED ID' do
    str = 'This is NOT a DOI: 123456'

    expect(described_class.extract(str)).to be_empty
  end
end
