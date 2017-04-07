module Identifiers
  class DOI
    PATTERN = %r{
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
        \d{4,9} # Registrant code
        /       # Prefix/suffix divider
        \S+     # DOI suffix
      )
    }x
    VALID_ENDING = /
      (?:
        \p{^Punct}  # Non-punctuation character
        |
        \(.+\)      # Balanced parentheses
        |
        2-\#        # Early Wiley DOI suffix
      )
      \z
    /x

    def self.extract(str)
      str
        .to_s
        .downcase
        .scan(PATTERN)
        .map { |doi|
          next doi if doi =~ VALID_ENDING

          doi.sub(/\p{Punct}+\z/, '')
        }
    end
  end
end
