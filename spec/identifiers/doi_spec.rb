require 'identifiers/doi'

RSpec.describe Identifiers::DOI do
  OPTIONS = [{ strict: false }, { strict: true }].freeze

  def each_doi(file)
    Pathname.new(__FILE__).join('..', '..', 'fixtures', file).each_line do |doi|
      yield(doi.chomp!)
    end
  end

  OPTIONS.each do |options|
    context "when extracting with options set to #{options.inspect}" do
      it 'extracts DOIs from a string' do
        str = 'This is an example of a DOI: 10.1049/el.2013.3006'

        expect(described_class.extract(str, options)).to contain_exactly('10.1049/el.2013.3006')
      end

      it 'extracts DOIs from anywhere in a string' do
        str = 'This is an example of a DOI - 10.1049/el.2013.3006 - which is entirely valid'

        expect(described_class.extract(str, options)).to contain_exactly('10.1049/el.2013.3006')
      end

      it 'downcases the DOIs extracted' do
        str = 'This is an example of a DOI: 10.1097/01.ASW.0000443266.17665.19'

        expect(described_class.extract(str, options)).to contain_exactly('10.1097/01.asw.0000443266.17665.19')
      end

      it 'does not extract a PubMed ID' do
        str = 'This is NOT a DOI: 123456'

        expect(described_class.extract(str, options)).to be_empty
      end

      it 'returns no DOIs if given nothing' do
        expect(described_class.extract(nil)).to be_empty
      end

      it 'extracts ISBN-As' do
        str = 'This is an ISBN-A: 10.978.8898392/315'

        expect(described_class.extract(str, options)).to contain_exactly('10.978.8898392/315')
      end

      it 'does not extract invalid ISBN-As' do
        str = 'This is not an ISBN-A: 10.978.8898392/NotARealIsbnA'

        expect(described_class.extract(str, options)).to be_empty
      end

      it 'retains closing parentheses that are part of the DOI' do
        str = 'This is an example of a DOI: 10.1130/2013.2502(04)'

        expect(described_class.extract(str, options)).to contain_exactly('10.1130/2013.2502(04)')
      end

      it 'discards ellipses' do
        str = 'This is an example of a DOI: 10.1130/2013.2502…'

        expect(described_class.extract(str, options)).to contain_exactly('10.1130/2013.2502')
      end

      it 'extracts old Wiley DOIs' do
        str = 'This is an example of an old Wiley DOI: 10.1002/(SICI)1096-8644(199601)99:1<135::AID-AJPA8>3.0.CO;2-# 10.1002/(sici)1099-0690(199806)1998:6<1071::aid-ejoc1071>3.0.co;2-5'

        expect(described_class.extract(str, options)).to contain_exactly('10.1002/(sici)1096-8644(199601)99:1<135::aid-ajpa8>3.0.co;2-#', '10.1002/(sici)1099-0690(199806)1998:6<1071::aid-ejoc1071>3.0.co;2-5')
      end

      it 'does not extract a closing parenthesis if not part of the DOI' do
        str = '(This is an example of a DOI: 10.1130/2013.2502)'

        expect(described_class.extract(str, options)).to contain_exactly('10.1130/2013.2502')
      end

      it 'discards trailing punctuation from old Wiley DOIs' do
        str = 'This is an example of an old Wiley DOI: 10.1002/(SICI)1096-8644(199601)99:1<135::AID-AJPA8>3.0.CO;2-#",'

        expect(described_class.extract(str, options)).to contain_exactly('10.1002/(sici)1096-8644(199601)99:1<135::aid-ajpa8>3.0.co;2-#')
      end

      it 'discards trailing Unicode punctuation after balanced parentheses' do
        str = 'This is an example of a DOI: 10.1130/2013.2502(04)…",'

        expect(described_class.extract(str, options)).to contain_exactly('10.1130/2013.2502(04)')
      end

      it 'discards contiguous trailing punctuation after unbalanced parentheses' do
        str = '(This is an example of a DOI: 10.1130/2013.2502).",'

        expect(described_class.extract(str, options)).to contain_exactly('10.1130/2013.2502')
      end

      it 'does not extract DOIs with purely punctuation suffixes' do
        expect(described_class.extract('10.1130/!).",', options)).to be_empty
      end

      it 'extracts DOIs with emoji in them' do
        expect(described_class.extract('10.1234/🐔💩123🐔🐔🐔123', options)).to contain_exactly('10.1234/🐔💩123🐔🐔🐔123')
      end

      it 'extracts DOIs separated by Unicode whitespace' do
        expect(described_class.extract('10.1234/foo  10.1234/bar', options)).to contain_exactly('10.1234/foo', '10.1234/bar')
      end

      it 'does not extract DOIs with extra digits prefixed' do
        expect(described_class.extract('110.1234/foo', options)).to be_empty
      end

      it 'extracts DOIs from a string with trailing closing parentheses' do
        expect(described_class.extract('(10.1130/2013.2502(04))', options)).to contain_exactly('10.1130/2013.2502(04)')
      end

      it 'extracts DOIs from a string with multiple trailing closing parentheses' do
        expect(described_class.extract('10.1130/2013.2502(04))))', options)).to contain_exactly('10.1130/2013.2502(04)')
      end

      it 'extracts DOIs with parentheses within the suffix' do
        expect(described_class.extract('10.1016/0005-2744(70)90072-0', options)).to contain_exactly('10.1016/0005-2744(70)90072-0')
      end

      it 'extracts all DOIs from a Crossref sample' do
        each_doi('dois.txt') { |doi|
          expect(described_class.extract(doi, options)).to contain_exactly(doi)
        }
      end
    end
  end

  context 'when no options are provided' do
    it 'discards trailing punctuation' do
      str = 'This is an example of a DOI: 10.1130/2013.2502.'

      expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502')
    end

    it 'discards multiple contiguous trailing punctuation' do
      str = 'This is an example of a DOI: 10.1130/2013.2502...",'

      expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502')
    end

    it 'discards trailing punctuation after balanced parentheses' do
      str = 'This is an example of a DOI: This is an example of a DOI: 10.1130/2013.2502(04).'

      expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502(04)')
    end

    it 'discards contiguous trailing punctuation after balanced parentheses' do
      str = 'This is an example of a DOI: This is an example of a DOI: 10.1130/2013.2502(04).",'

      expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502(04)')
    end

    it 'does not overflow when given lots of trailing punctuation' do
      str = '10.1130/2013.2502' + ('.' * 10000)

      expect(described_class.extract(str)).to contain_exactly('10.1130/2013.2502')
    end
  end

  context 'with strict mode on' do
    it 'extracts DOIs ending with trailing periods' do
      str = 'This is an example of a DOI: 10.1130/2013.2502...",'

      expect(described_class.extract(str, strict: true)).to contain_exactly('10.1130/2013.2502...')
    end

    it 'keeps trailing punctuation after balanced parentheses' do
      str = 'This is an example of a DOI: This is an example of a DOI: 10.1130/2013.2502(04).'

      expect(described_class.extract(str, strict: true)).to contain_exactly('10.1130/2013.2502(04).')
    end

    it 'discards contiguous trailing punctuation after balanced parentheses' do
      str = 'This is an example of a DOI: This is an example of a DOI: 10.1130/2013.2502(04).",'

      expect(described_class.extract(str, strict: true)).to contain_exactly('10.1130/2013.2502(04).')
    end

    it 'limits the trailing periods to 3' do
      str = 'This is an example of a DOI: 10.1130/2013.2502.......'

      expect(described_class.extract(str, strict: true)).to contain_exactly('10.1130/2013.2502...')
    end

    it 'extracts all DOIs from a Crossref sample, keeping the trailing periods' do
      each_doi('strict_mode_dois.txt') { |doi|
        expect(described_class.extract(doi, strict: true)).to contain_exactly(doi)
      }
    end
  end
end
