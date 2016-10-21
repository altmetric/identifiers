module Identifiers
  class RepecId
    def self.extract(str)
      str.scan(/\brepec:\S+\b/i).map { |repec| "RePEc:#{repec.split(':', 2).last}" }
    end
  end
end
