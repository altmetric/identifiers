require 'pry-byebug'

module Identifiers
  class ISBN
    InvalidISBNError = Class.new(StandardError)

    ISBN_13_REGEXP = /
      \b
      97[89]            # ISBN (GS1) Bookland prefix
      [\p{Pd}\p{Zs}]?   # Optional hyphenation
      (?:
        \d              # Digit
        [\p{Pd}\p{Zs}]? # Optional hyphenation
      ){9}
      \d                # Check digit
      \b
    /x
    ISBN_10_REGEXP = /
      (?<!              # Don't match a hyphenated or spaced ISBN-13
        97[89]
        [\p{Pd}\p{Zs}]
      )
      \b
      (?:
        \d              # Digit
        [\p{Pd}\p{Zs}]? # Optional hyphenation
      ){9}
      [\dX]             # Check digit
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

    def self.extract(str)
      scan(str).map { |isbn| ISBN.new(isbn).normalize.to_s }
    end

    def self.scan(str)
      scan_isbn_as(str) + scan_thirteen_digit_isbns(str) + scan_ten_digit_isbns(str)
    end

    def self.extract_isbn_as(str)
      extract_thirteen_digit_isbns(str.to_s.scan(ISBN_A_REGEXP).join("\n").tr('/.', ''))
    end

    def self.scan_isbn_as(str)
      scan_thirteen_digit_isbns(str.to_s.scan(ISBN_A_REGEXP).join("\n").tr('/.', ''))
    end

    def self.extract_thirteen_digit_isbns(str)
      scan_thirteen_digit_isbns(str).map { |isbn| ISBN.new(str).normalize.to_s }
    end

    def self.scan_thirteen_digit_isbns(str)
      str
        .to_s
        .scan(ISBN_13_REGEXP)
        .select { |isbn| valid_isbn_13?(isbn) }
    end

    def self.extract_ten_digit_isbns(str)
      scan_ten_digit_isbns(str).map { |isbn|
        isbn = ISBN.new(isbn).normalize.to_s
        isbn.chop!
        isbn.prepend('978')
        isbn << isbn_13_check_digit(isbn).to_s

        isbn
      }
    end

    def self.scan_ten_digit_isbns(str)
      str
        .to_s
        .scan(ISBN_10_REGEXP)
        .select { |isbn| valid_isbn_10?(isbn) }
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
      return false unless isbn =~ ISBN_13_REGEXP

      result = digits_of(isbn).zip([1, 3].cycle).map { |digit, weight| digit * weight }.reduce(:+)

      (result % 10).zero?
    end

    def self.valid_isbn_10?(isbn)
      return false unless isbn =~ ISBN_10_REGEXP

      result = digits_of(isbn).with_index.map { |digit, weight| digit * weight.succ }.reduce(:+)

      (result % 11).zero?
    end

    def self.digits_of(isbn)
      ISBN.new(isbn).normalize.to_s.each_char.map { |char| char == 'X' ? 10 : Integer(char) }.to_enum
    end

    attr_reader :isbn

    def initialize(isbn)
      isbn = isbn.to_s
      fail InvalidISBNError, "bad ISBN(is not ISBN?): #{isbn}" if not_valid?(isbn)

      @isbn = isbn
    rescue
      # binding.pry
    end

    def not_valid?(str)
      str.scan(ISBN_A_REGEXP).empty? && str.scan(ISBN_13_REGEXP).empty? && str.scan(ISBN_10_REGEXP).empty?
    end

    def normalize
      ISBN.new(isbn.gsub(/[\p{Pd}\p{Zs}]/, ''))
    end

    def to_s
      isbn
    end
  end
end
