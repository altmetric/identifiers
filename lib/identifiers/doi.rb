module Identifiers
  class DOI
    def self.extract(str)
      str.scan(%r{\b10\.\d{3,}/\S+\b}).map(&:downcase)
    end
  end
end
