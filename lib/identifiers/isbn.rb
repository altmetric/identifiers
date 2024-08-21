# frozen_string_literal: true

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
    /x.freeze
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
    /x.freeze
    ISBN_A_REGEXP = %r{
      \b
      (?<=10\.) # Directory indicator (always 10)
      97[89]\.  # ISBN (GS1) Bookland prefix
      \d{2,8}   # ISBN registration group element and publisher prefix
      /         # Prefix/suffix divider
      \d{1,7}   # ISBN title enumerator and check digit
      \b
    }x.freeze

    def self.extract(str, prefixes = [])
      return extract_with_prefix(str, prefixes) if prefixes.any?

      extract_isbn_as(str) + extract_thirteen_digit_isbns(str) + extract_ten_digit_isbns(str)
    end

    def self.extract_with_prefix(str, prefixes)
      prefix_regexp = generate_prefix_regexp(prefixes)

      [isbn_a_candidate_matcher, ISBN_13_REGEXP, ISBN_10_REGEXP].inject([]) do |matches, isbn_regexp|
        matches | isbn_with_prefix_candidates(str, prefix_regexp, isbn_regexp)
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
        .map do |isbn|
          isbn.chop!
          isbn.prepend('978')
          isbn << isbn_13_check_digit(isbn).to_s

          isbn
        end
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

    def self.isbn_with_prefix_candidates(str, prefix_regexp, isbn_regexp)
      regexp = Regexp.new("#{prefix_regexp}#{isbn_regexp}", Regexp::IGNORECASE | Regexp::EXTENDED)

      str
        .to_s
        .scan(regexp)
        .filter_map do |match|
          extract(Array(match).first)&.first
        end
    end

    def self.generate_prefix_regexp(prefixes)
      joined_prefixes = Regexp.union(prefixes).source

      Regexp.new(
        "(?<=                 # Lookbehind for a prefix
           #{joined_prefixes} # ie:p1|p2|p3
         )
         :?                   # Optional colon. If you want to use a different separator, you can add it as a prefix
         \\s*                 # Optional whitespaces
         ", Regexp::IGNORECASE | Regexp::EXTENDED
      )
    end

    def self.isbn_a_candidate_matcher
      # We capture the ISBN-A prefix for the ISBN-A regexp to work correctly when extracting ISBN-As
      Regexp.new(ISBN_A_REGEXP.source.gsub('(?<=10\\.)', '10\.'), Regexp::IGNORECASE | Regexp::EXTENDED)
    end
  end
end
