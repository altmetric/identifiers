module Identifiers
  class ISBN
    REGEX_13 = /\b97[89]\d{10}\b/
    REGEX_10 = /\b\d{9}(?:\d|X)\b/

    def self.extract(str)
      extract_thirteen_digit_isbns(str) + extract_ten_digit_isbns(str)
    end

    def self.extract_thirteen_digit_isbns(str)
      str.gsub(/(?<=\d)[- ](?=\d)/, '').scan(REGEX_13).select { |isbn| valid_isbn_13?(isbn) }
    end

    def self.extract_ten_digit_isbns(str)
      str.gsub(/(?<=\d)[- ](?=[\dX])/i, '').scan(REGEX_10).select { |isbn| valid_isbn_10?(isbn) }.map { |isbn|
        isbn.chop!
        isbn.prepend('978')
        isbn << isbn_13_check_digit(isbn).to_s

        isbn
      }
    end

    def self.isbn_13_check_digit(isbn)
      sum = isbn.each_char.zip([1, 3].cycle).reduce(0) { |sum, values| sum + (Integer(values[0]) * values[1]) }
      check_digit = 10 - (sum % 10)

      if check_digit == 10
        0
      else
        check_digit
      end
    end

    def self.valid_isbn_13?(isbn)
      return false unless isbn =~ REGEX_13

      result = isbn.each_char.zip([1, 3].cycle).reduce(0) { |sum, values| sum + (Integer(values[0]) * values[1]) }

      (result % 10).zero?
    end

    def self.valid_isbn_10?(isbn)
      return false unless isbn =~ REGEX_10

      result = isbn.each_char.with_index.reduce(0) { |sum, values|
        sum + (Integer(values[0].sub('X', '10')) * values[1].succ)
      }

      (result % 11).zero?
    end
  end
end
