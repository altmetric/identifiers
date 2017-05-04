module Identifiers
  class ISBN
    REGEX_13 = /\b97[89]\d{10}\b/
    REGEX_10 = /\b\d{9}(?:\d|X)\b/
    REGEX_A = %r{\b(?<=10\.)97[89]\.\d{2,8}/\d{1,7}\b}

    def self.extract(str)
      extract_isbn_as(str) + extract_thirteen_digit_isbns(str) + extract_ten_digit_isbns(str)
    end

    def self.extract_isbn_as(str)
      isbn_as = str.to_s.scan(REGEX_A).join("\n").tr('/.', '')

      extract_thirteen_digit_isbns(isbn_as)
    end

    def self.extract_thirteen_digit_isbns(str)
      str
        .to_s
        .gsub(/(?<=\d)[\p{Pd}\p{Zs}](?=\d)/, '')
        .scan(REGEX_13)
        .select { |isbn| valid_isbn_13?(isbn) }
    end

    def self.extract_ten_digit_isbns(str)
      str
        .to_s
        .gsub(/(?<=\d)[\p{Pd}\p{Zs}](?=[\dX])/i, '')
        .scan(REGEX_10)
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
      return false unless isbn =~ REGEX_13

      result = digits_of(isbn).zip([1, 3].cycle).map { |digit, weight| digit * weight }.reduce(:+)

      (result % 10).zero?
    end

    def self.valid_isbn_10?(isbn)
      return false unless isbn =~ REGEX_10

      result = digits_of(isbn).with_index.map { |digit, weight| digit * weight.succ }.reduce(:+)

      (result % 11).zero?
    end

    def self.digits_of(isbn)
      isbn.to_s.each_char.map { |char| char == 'X' ? 10 : Integer(char) }.to_enum
    end
  end
end
