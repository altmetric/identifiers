module Identifiers
  class PubmedId
    def self.extract(str)
      str
        .scan(/(?<=^|\s)0*(?!0)(\d+)(?=$|\s)/)
        .flatten
    end
  end
end
