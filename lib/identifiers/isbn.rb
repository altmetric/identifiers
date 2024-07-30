module Identifiers
  class ISBN
    ISBN_13_REGEXP = /
      \b
      (
        97[89]            # ISBN (GS1) Bookland prefix
        ([\p{Pd}\p{Zs}])? # Optional hyphenation
        (?:
          \d              # Digit
          \2?             # Optional hyphenation
        ){9}
        \d                # Check digit
      )
      \b
    /x
    ISBN_10_REGEXP = /
      (?<!              # Don't match a hyphenated or spaced ISBN-13
        97[89]
        [\p{Pd}\p{Zs}]
      )
      \b
      (
        \d{1,5}           # Registration group identifier
        ([\p{Pd}\p{Zs}])? # Optional hyphenation
        (?:
          \d              # Digit
          \2?             # Optional hyphenation
        ){4,8}
        [\dX]             # Check digit
      )
      \b
    /x
    ISBN_A_REGEXP = %r{
      \b
      (?<=10\.) # Directory indicator (always 10)
      97[89]\.  # ISBN (GS1) Bookland prefix
      \d{2,8}   # ISBN registration group element and publisher prefix
      /         # Prefix/suffix divider
      \d{1,7}   # ISBN title enumerator and check digit
      \b
    }x
    TEXT_AFTER_PREFIX_REGEXP = ':?\s*(\d.*)$'.freeze

    def self.extract(str , prefixes = [])
      str = match_strings_with_prefix(str , prefixes) if prefixes.any?

      extract_isbn_as(str) + extract_thirteen_digit_isbns(str) + extract_ten_digit_isbns(str)
    end

    def self.match_strings_with_prefix(str, prefixes)
      prefix_regexp = prefixes.join('|')

      str
        .to_s
        .scan(/(#{prefix_regexp})#{TEXT_AFTER_PREFIX_REGEXP}/i)
        .inject('') do |acum, (_prefix, match)|
          acum += "#{match} \n "
        end
    end

    def self.extract_isbn_as(str)
      extract_thirteen_digit_isbns(str.to_s.scan(ISBN_A_REGEXP).join("\n").tr('/.', ''))
    end

    def self.extract_thirteen_digit_isbns(str)
      str
        .to_s
        .scan(ISBN_13_REGEXP)
        .select { |isbn, hyphen| !hyphen || isbn.count(hyphen) == 4 }
        .map { |isbn, hyphen| isbn.delete(hyphen.to_s) }
        .select { |isbn| valid_isbn_13?(isbn) }
    end

    def self.extract_ten_digit_isbns(str)
      str
        .to_s
        .scan(ISBN_10_REGEXP)
        .select { |isbn, hyphen| !hyphen || isbn.count(hyphen) == 3 }
        .map { |isbn, hyphen| isbn.delete(hyphen.to_s) }
        .select { |isbn| valid_isbn_10?(isbn) }
        .map { |isbn|
          isbn.chop!
          isbn.prepend('978')
          isbn << isbn_13_check_digit(isbn).to_s

          isbn
        }
    end

    def self.isbn_13_check_digit(isbn)
      sum = digits_of(isbn).zip([1, 3].cycle).map { |digit, weight| digit * weight }.reduce(:+)
      check_digit = 10 - (sum % 10)

      if check_digit == 10
        0
      else
        check_digit
      end
    end

    def self.valid_isbn_13?(isbn)
      return false unless String(isbn).length == 13 && isbn =~ ISBN_13_REGEXP

      result = digits_of(isbn).zip([1, 3].cycle).map { |digit, weight| digit * weight }.reduce(:+)

      (result % 10).zero?
    end

    def self.valid_isbn_10?(isbn)
      return false unless String(isbn).length == 10 && isbn =~ ISBN_10_REGEXP

      result = digits_of(isbn).with_index.map { |digit, weight| digit * weight.succ }.reduce(:+)

      (result % 11).zero?
    end

    def self.digits_of(isbn)
      isbn.to_s.each_char.map { |char| char == 'X' ? 10 : Integer(char) }.to_enum
    end
  end
end
