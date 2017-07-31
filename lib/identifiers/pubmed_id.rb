module Identifiers
  class PubmedId
    def self.extract(str)
      str.to_s.scan(/(?<=^|[[:space:]])0*(?!0)(\d+)(?=$|[[:space:]])/).flatten
    end
  end
end
