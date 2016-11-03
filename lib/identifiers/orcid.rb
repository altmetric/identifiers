module Identifiers
  class ORCID
    REGEX = /\b(?:\d{4}-){3}\d{3}[\dx]\b/i

    def self.extract(str)
      str.scan(REGEX).select { |orcid| valid?(orcid) }.map(&:upcase)
    end

    def self.valid?(str)
      digit = calculate_digit(str)
      return false unless digit

      digit == str[-1].upcase
    end

    def self.calculate_digit(str)
      return unless str =~ REGEX

      base_digits = str.chop.tr('-', '')
      total = 0
      base_digits.each_char { |c| total = (total + Integer(c)) * 2 }
      remainder = total % 11
      result = (12 - remainder) % 11
      result == 10 ? 'X' : result.to_s
    end
  end
end
