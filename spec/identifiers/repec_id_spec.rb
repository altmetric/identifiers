require 'identifiers/repec_id'

RSpec.describe Identifiers::RepecId do
  it 'extracts RePEc IDs' do
    str = "RePEc:wbk:wbpubs:2266\nRePEc:inn:wpaper:2016-03"

    expect(described_class.extract(str)).to contain_exactly('RePEc:wbk:wbpubs:2266', 'RePEc:inn:wpaper:2016-03')
  end

  it 'normalizes RePec IDs' do
    str = "REPEC:wbk:wbpubs:2266\nrepec:inn:wpaper:2016-03"

    expect(described_class.extract(str)).to contain_exactly('RePEc:wbk:wbpubs:2266', 'RePEc:inn:wpaper:2016-03')
  end

  it 'extracts RePEc IDs separated by Unicode whitespace' do
    str = "RePEc:wbk:wbpubs:2266 RePEc:inn:wpaper:2016-03"

    expect(described_class.extract(str)).to contain_exactly('RePEc:wbk:wbpubs:2266', 'RePEc:inn:wpaper:2016-03')
  end

  it 'stops before URL queries, fragments, and parameters' do
    str = <<~TEXT
      RePEc:wbk:wbpubs:2266?utm_source=readme
      RePEc:inn:wpaper:2016-03#section
      https://socionet.example/item?h=RePEc:rpc:rdfdoc:redif&utm_source=readme
    TEXT

    expect(described_class.extract(str)).to contain_exactly(
      'RePEc:wbk:wbpubs:2266',
      'RePEc:inn:wpaper:2016-03',
      'RePEc:rpc:rdfdoc:redif'
    )
  end

  it 'extracts nothing when given empty arguments' do
    expect(described_class.extract(nil)).to be_empty
  end
end
