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

    def self.extract(str)
      str
        .scan(PATTERN)
        .map { |doi|
          next doi.downcase if doi !~ /\p{Punct}\z/ || doi =~ /\(.+\)\z/

          doi.downcase.chop
        }
    end
  end
end
