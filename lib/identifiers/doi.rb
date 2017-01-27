module Identifiers
  class DOI
    def self.extract(str)
      str.scan(%r{\b10\.(?:97[89]\.\d{2,8}/\d{1,7}|\d{4,9}/\S+)\b}).map(&:downcase)
    end
  end
end
