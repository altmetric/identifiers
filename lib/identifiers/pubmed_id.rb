module Identifiers
  class PubmedId
    def self.extract(str)
      str = str.to_s
      str.scan(/(?<=^|[[:space:]])0*(?!0)(\d+)(?=$|[[:space:]])/).flatten |
        str.scan(%r{https?://(?:www\.)?ncbi.nlm.nih.gov/pubmed/(\d+)}).flatten
    end
  end
end
