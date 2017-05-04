module Identifiers
  class AdsBibcode
    def self.extract(str)
      str.to_s.scan(/\b\d{4}[a-z][0-9a-z&.]{14}\b/i)
    end
  end
end
