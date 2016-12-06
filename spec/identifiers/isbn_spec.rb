require 'identifiers/isbn'

RSpec.describe Identifiers::ISBN do
  it 'extracts a ISBN' do
    expect(described_class.extract('ISBN: 9780805069099')).to contain_exactly('9780805069099')
  end

  it 'normalizes 13-digit ISBNs' do
    str = "978-0-80-506909-9\n978-0-67-187919-8"

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9780671879198')
  end

  it 'normalizes 10-digit ISBNs' do
    str = "0-8050-6909-7 \n 2-7594-0269-X"

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9782759402694')
  end

  it 'normalizes 10-digit ISBNs with a check digit of 10' do
    expect(described_class.extract('4423272350')).to contain_exactly('9784423272350')
  end

  it 'does not extract invalid 13-digit ISBNs' do
    expect(described_class.extract('9783319217280')).to be_empty
  end

  it 'does not extract invalid 10-digit ISBNs' do
    expect(described_class.extract('3319217280')).to be_empty
  end
end
