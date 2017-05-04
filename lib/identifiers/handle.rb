module Identifiers
  class Handle
    def self.extract(str)
      str.to_s.scan(%r{\b[0-9.]+/[^[:space:]]+\b}i)
    end
  end
end
