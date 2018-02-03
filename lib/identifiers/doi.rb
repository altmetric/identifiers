module Identifiers
  class DOI
    REGEXP = %r{
      \b
      10 # Directory indicator (always 10)
      \.
      (?:
        # ISBN-A
        97[89]\. # ISBN (GS1) Bookland prefix
        \d{2,8}  # ISBN registration group element and publisher prefix
        /        # Prefix/suffix divider
        \d{1,7}  # ISBN title enumerator and check digit
        |
        # DOI
        \d{4,9}       # Registrant code
        /             # Prefix/suffix divider
        [^[:space:]]+ # DOI suffix
      )
    }x
    VALID_ENDING = /
      (?:
        \p{^Punct} # Non-punctuation character
        |
        \(.+\)     # Balanced parentheses
        |
        2-\#       # Early Wiley DOI suffix
      )
      \z
    /x

    def self.extract(str)
      str.to_s.downcase.scan(REGEXP).map { |doi| extract_one(doi) }.compact
    end

    def self.extract_one(str)
      while (match = str.to_s.downcase[REGEXP])
        break match if match =~ VALID_ENDING

        str = match.sub(/\p{Punct}\z/, '')
      end
    end
  end
end
