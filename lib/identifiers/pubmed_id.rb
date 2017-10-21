module Identifiers
  class PubmedId
    def self.extract(str)
      new(str).extract
    end

    attr_reader :pubmed_candidate
    private :pubmed_candidate

    URL_REGEX = %r{^https?://(?:www\.)?ncbi.nlm.nih.gov/pubmed/}

    def initialize(pubmed_candidate)
      @pubmed_candidate = pubmed_candidate.to_s
    end

    def extract
      extract_from_number | extract_from_pubmed_url
    end

    private

    def extract_from_pubmed_url
      return [] unless contains_pubmed_id?

      Array(pubmed_id_from_url)
    end

    def contains_pubmed_id?
      pubmed_candidate =~ URL_REGEX
    end

    def pubmed_id_from_url
      pubmed_candidate.sub(URL_REGEX, '')
    end

    def extract_from_number
      pubmed_candidate.scan(/(?<=^|[[:space:]])0*(?!0)(\d+)(?=$|[[:space:]])/).flatten
    end
  end
end
