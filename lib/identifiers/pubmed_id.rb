module Identifiers
  class PubmedId
    def self.extract(str)
      str.scan(/(?<=^|\s)\d+(?=$|\s)/)
    end
  end
end
