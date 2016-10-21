module Identifiers
  class Handle
    def self.extract(str)
      str.scan(%r{\b[0-9.]+/\S+\b}i)
    end
  end
end
