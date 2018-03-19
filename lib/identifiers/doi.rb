module Identifiers
  class DOI
    REGEXP = %r{
      \b
      10                                      # Directory indicator (always 10)
      \.
      (?:
        # ISBN-A
        97[89]\.                              # ISBN (GS1) Bookland prefix
        \d{2,8}                               # ISBN registration group element and publisher prefix
        /                                     # Prefix/suffix divider
        \d{1,7}                               # ISBN title enumerator and check digit
        |
        # DOI
        \d{4,9}                               # Registrant code
        /                                     # Prefix/suffix divider
        (?:
          # DOI suffix
          [^[:space:]]+2-\#                   # Early Wiley suffix
          |
          [^[:space:]]+\([^[:space:])]+\)     # Suffix ending in balanced parentheses
          |
          [^[:space:]]+(?![[:space:]])\p{^P}  # Suffix ending in non-punctuation
        )
      )
    }x

    def self.extract(str)
      str.to_s.downcase.scan(REGEXP)
    end
  end
end
