require 'identifiers/isbn'

RSpec.describe Identifiers::ISBN do
  it 'extracts a ISBN' do
    expect(described_class.extract('ISBN: 9780805069099')).to contain_exactly('9780805069099')
  end

  it 'extracts ISBNs when given as a number' do
    isbn = 9780805069099

    expect(described_class.extract(isbn)).to contain_exactly('9780805069099')
  end

  it 'normalizes 13-digit ISBNs' do
    str = "978-0-80-506909-9\n978-0-67-187919-8"

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9780671879198')
  end

  it 'extracts multiple ISBN-13s separated by a space' do
    str = '978-0-80-506909-9 978-0-67-187919-8'

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9780671879198')
  end

  it 'extracts ISBNs with hyphens' do
    expect(described_class.extract('ISBN: 978-0-80-506909-9')).to contain_exactly('9780805069099')
  end

  it 'extracts ISBNs with Unicode dashes' do
    expect(described_class.extract('ISBN: 978–0–80–506909–9')).to contain_exactly('9780805069099')
  end

  it 'extracts ISBNs with spaces' do
    expect(described_class.extract('ISBN: 978 0 80 506909 9')).to contain_exactly('9780805069099')
  end

  it 'extracts ISBNs with Unicode spaces' do
    expect(described_class.extract('ISBN: 978 0 80 506909 9')).to contain_exactly('9780805069099')
  end

  it 'extracts ISBN-13s from ISBN-As' do
    expect(described_class.extract('10.978.8898392/315')).to contain_exactly('9788898392315')
  end

  it 'does not extract invalid ISBNs from ISBN-As' do
    expect(described_class.extract('10.978.8898392/316')).to be_empty
  end

  it 'normalizes 10-digit ISBNs' do
    str = "0-8050-6909-7 \n 2-7594-0269-X"

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9782759402694')
  end

  it 'extracts multiple 10-digit ISBNs separated by a space' do
    str = '0-8050-6909-7 2-7594-0269-X'

    expect(described_class.extract(str)).to contain_exactly('9780805069099', '9782759402694')
  end

  it 'normalizes 10-digit ISBNs with Unicode dashes' do
    expect(described_class.extract('0–8050–6909–7')).to contain_exactly('9780805069099')
  end

  it 'normalizes 10-digit ISBNs with a check digit of 10' do
    expect(described_class.extract('4423272350')).to contain_exactly('9784423272350')
  end

  it 'normalizes 10-digit ISBNs with spaces' do
    expect(described_class.extract('0 8050 6909 7')).to contain_exactly('9780805069099')
  end

  it 'normalizes 10-digit ISBNs with Unicode spaces' do
    expect(described_class.extract('0 8050 6909 7')).to contain_exactly('9780805069099')
  end

  it 'normalizes 10-digit ISBNs with spaces and a check digit of X' do
    expect(described_class.extract('2 7594 0269 X')).to contain_exactly('9782759402694')
  end

  it 'does not extract invalid 13-digit ISBNs' do
    expect(described_class.extract('9783319217280')).to be_empty
  end

  it 'does not extract invalid 10-digit ISBNs' do
    expect(described_class.extract('3319217280')).to be_empty
  end

  it 'does not extract ISBN-10s from hyphenated ISBN-13s' do
    expect(described_class.extract('978-0-309-57079-4')).to contain_exactly('9780309570794')
  end

  it 'does not extract ISBN-10s from space-separated ISBN-13s' do
    expect(described_class.extract('978 0 309 57079 4')).to contain_exactly('9780309570794')
  end

  describe '#initialize' do
    it 'allows a valid ISBN' do
      expect(described_class.new('2-7594-0269-X')).to be_an_instance_of(described_class)
    end

    it 'fails when a not valid ISBN is supplied' do
      expect { described_class.new('foobar') }.to raise_error(described_class::InvalidISBNError, 'bad ISBN(is not ISBN?): foobar')
    end
  end

  describe '#isbn10?' do
    it 'returns true for 10-digit ISBNs' do
      isbn = described_class.new('2-7594-0269-X')

      expect(isbn.isbn10?).to eq(true)
    end

    it 'returns false for 13-digit ISBNs' do
      isbn = described_class.new('9780309570794')

      expect(isbn.isbn10?).to eq(false)
    end
  end

  describe '#isbn13?' do
    it 'returns true for 13-digit ISBNs' do
      isbn = described_class.new('9780309570794')

      expect(isbn.isbn13?).to eq(true)
    end

    it 'returns false for 10-digit ISBNs' do
      isbn = described_class.new('2-7594-0269-X')

      expect(isbn.isbn13?).to eq(false)
    end
  end

  describe '#isbn10' do
    it 'returns the ISBN in 10-digit format' do
      isbn = described_class.new('0-309-57079-4')

      expect(isbn.isbn10).to eq('0-309-57079-4')
    end

    it 'returns error when the ISBN cannot be converted'
  end

  describe '#isbn13' do
    it 'returns the ISBN in 13-digit format'
  end

  describe '#normalize' do
    it 'returns the ISBN as 13-digit without dashes or spaces'
  end
end
