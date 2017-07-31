module Identifiers
  class ArxivId
    POST_2007_REGEXP = %r{
      (?<=^|[[:space:]/])  # Look-behind for the start of the string, whitespace or a forward slash
      (?:arXiv:)?       # Optional arXiv scheme
      \d{4}             # YYMM (two-digit year and two-digit month number)
      \.
      \d{4,5}           # Zero-padded sequence number of 4- or 5-digits
      (?:v\d+)?         # Literal v followed by version number of 1 or more digits
      (?=$|[[:space:]])    # Look-ahead for end of string or whitespace
    }xi
    PRE_2007_REGEXP = %r{
      (?<=^|[[:space:]/])  # Look-behind for the start of the string, whitespace or a forward slash
      (?:arXiv:)?       # Optional arXiv scheme
      [a-z-]+           # Archive (e.g. "math")
      (?:\.[A-Z]{2})?   # Subject class (where applicable)
      /
      \d{2}             # Year
      (?:0[1-9]|1[012]) # Month
      \d{3}             # Number
      (?:v\d+)?         # Literal v followed by version number of 1 or more digits
      (?=$|[[:space:]])    # Look-ahead for end of string or whitespace
    }xi

    def self.extract(str)
      extract_pre_2007_arxiv_ids(str) + extract_post_2007_arxiv_ids(str)
    end

    def self.extract_post_2007_arxiv_ids(str)
      str.to_s.scan(POST_2007_REGEXP).map { |arxiv_id| arxiv_id.sub(/\AarXiv:/i, '') }
    end

    def self.extract_pre_2007_arxiv_ids(str)
      str.to_s.scan(PRE_2007_REGEXP).map { |arxiv_id| arxiv_id.sub(/\AarXiv:/i, '') }
    end
  end
end
