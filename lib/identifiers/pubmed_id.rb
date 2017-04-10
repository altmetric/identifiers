module Identifiers
  class PubmedId
    def self.extract(str)
      str
        .scan(/(?<=^|[[:space:]])0*(?!0)(\d+)(?=$|[[:space:]])/)
        .flatten
    end
  end
end
