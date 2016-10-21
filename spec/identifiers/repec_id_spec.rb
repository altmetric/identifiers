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
end
