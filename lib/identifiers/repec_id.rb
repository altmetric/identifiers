module Identifiers
  class RepecId
    def self.extract(str)
      str
        .to_s
        .scan(/\brepec:[^[:space:]]+\b/i)
        .map { |repec| "RePEc:#{repec.split(':', 2).last}" }
    end
  end
end
