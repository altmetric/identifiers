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

  it 'does not extract ISBN-13s from strings with inconsistent hyphenation' do
    expect(described_class.extract('978-0 80-506909 9')).to be_empty
  end

  it 'does not extract ISBN-10s from strings with inconsistent hyphenation' do
    expect(described_class.extract('0-8050 6909-7')).to be_empty
  end

  it 'does not extract ISBN-13s if they have more than five groups' do
    expect(described_class.extract('978-0-80-506-909-9')).to be_empty
  end

  it 'does not extract ISBN-13s if they have less than five groups' do
    expect(described_class.extract('978-0-80506909-9')).to be_empty
  end

  it 'does not extract ISBN-10s if they have more than four groups' do
    expect(described_class.extract('0-8050-69-09-7')).to be_empty
  end

  it 'does not extract ISBN-10s if they have less than four groups' do
    expect(described_class.extract('0-80506909-7')).to be_empty
  end

  it 'extracts ISBN-10s with variable width registration group identifiers' do
    expect(described_class.extract('99921-58-10-7 9971-5-0210-0 960-425-059-0 80-902734-1-6'))
      .to contain_exactly('9789992158104', '9789971502102', '9789604250592', '9788090273412')
  end

  context 'when passing prefixes' do
    it 'extracts only prefixed ISBNs' do
      text = "ISBN:9789992158104  ISBN-10 9789971502102 \n IsbN-13: 9789604250592 \n 9788090273412"
      prefixes = ['IsBn', 'ISBN-10', 'ISBN-13']

      expect(described_class.extract(text, prefixes))
        .to contain_exactly('9789992158104', '9789971502102', '9789604250592')
    end

    it 'extracts ISBNs with special characters in the prefixes' do
      text = "ISB*N:99921-58-10-7 IS?BN-10 9971-5-0210-0 Is$bN-13: 978-0-80-506909-9 80-902734-1-6"
      prefixes = ['IsB*n', 'IS?BN-10', 'IS$BN-13']

      expect(described_class.extract(text, prefixes))
        .to contain_exactly('9789992158104', '9789971502102', '9780805069099')
    end

    it 'extracts ISBNs with Unicode dashes' do
      text = "ISB*N:99921-58-10-7 IS?BN-10 9971-5-0210-0 Is$bN-13: 978–0–80–506909–9 80-902734-1-6"
      prefixes = ['IsB*n', 'IS?BN-10', 'IS$BN-13']

      expect(described_class.extract(text, prefixes))
        .to contain_exactly('9789992158104', '9789971502102', '9780805069099')
    end

    it 'extracts ISBNs with Unicode spaces' do
      text = "ISBN-13: 978 0 80 506909 9"
      prefixes = ['ISBN-13']

      expect(described_class.extract(text, prefixes)).to contain_exactly('9780805069099')
    end

    it 'normalizes 10-digit ISBNs with hyphens and a check digit of X' do
      expect(described_class.extract('ISBN:2-7594-0269-X', ['ISBN'])).to contain_exactly('9782759402694')
    end

    it 'normalizes 10-digit ISBNs with spaces and a check digit of X' do
      text = 'ISBN-10 2 7594 0269 X'
      prefixes = ['ISBN-10']

      expect(described_class.extract(text, prefixes)).to contain_exactly('9782759402694')
    end

    it 'does not extract ISBNs with different prefixes' do
      text = "ISBN:9789992158104 \n ISBN-10 9789971502102  IsbN-13: 9789604250592  9788090273412"
      prefixes = ['IsBn', 'ISBN-10']

      expect(described_class.extract(text, prefixes))
        .to contain_exactly('9789992158104', '9789971502102')
    end

    it 'does not extract ISBNs without prefixes' do
      text = "9789992158104 9789971502102 9789604250592 \n 9788090273412"
      prefixes = ['IsBn', 'ISBN-10', 'ISBN-13']

      expect(described_class.extract(text, prefixes)).to be_empty
    end
  end
end
