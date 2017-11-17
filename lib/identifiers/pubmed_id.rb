module Identifiers
  class PubmedId
    ZERO_PADDED_NUMBER = %r{(?<=^|[[:space:]])0*(?!0)(\d+)(?=$|[[:space:]])}
    PUBMED_URL = %r{https?://(?:www\.)?ncbi\.nlm\.nih\.gov/pubmed/0*(\d+)}i

    def self.extract(str)
      str = str.to_s
      str.scan(ZERO_PADDED_NUMBER).flatten | str.scan(PUBMED_URL).flatten
    end
  end
end
