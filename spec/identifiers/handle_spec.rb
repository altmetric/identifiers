require 'identifiers/handle'

RSpec.describe Identifiers::Handle do
  it 'extracts a Handle' do
    str = 'http://hdl.handle.net/10149/596901'

    expect(described_class.extract(str)).to contain_exactly('10149/596901')
  end

  it 'extracts another Handle' do
    str = 'http://hdl.handle.net/2117/83545it.ly/1UtXnTW'

    expect(described_class.extract(str)).to contain_exactly('2117/83545it.ly/1UtXnTW')
  end

  it 'discards queries and fragments from Handle resolver URLs' do
    str = <<~TEXT
      https://hdl.handle.net/10149/596901?utm_source=readme
      http://hdl.handle.net/10251/79612#details
    TEXT

    expect(described_class.extract(str)).to contain_exactly('10149/596901', '10251/79612')
  end

  it 'retains question marks and hashes in bare Handle suffixes' do
    str = '10149/report?appendix 10251/report#figure'

    expect(described_class.extract(str)).to contain_exactly('10149/report?appendix', '10251/report#figure')
  end

  it 'extracts Handles separated by Unicode whitespace' do
    str = '10149/596901 10251/79612'

    expect(described_class.extract(str)).to contain_exactly('10149/596901', '10251/79612')
  end

  it 'extracts nothing from empty arguments' do
    expect(described_class.extract(nil)).to be_empty
  end
end
