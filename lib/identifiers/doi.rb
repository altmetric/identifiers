module Identifiers
  class DOI
    REGEXP = %r{
      \b
      10                                        # Directory indicator (always 10)
      \.
      (?:
        # ISBN-A
        97[89]\.                                # ISBN (GS1) Bookland prefix
        \d{2,8}                                 # ISBN registration group element and publisher prefix
        /                                       # Prefix/suffix divider
        \d{1,7}                                 # ISBN title enumerator and check digit
        |
        # DOI
        \d{4,9}                                 # Registrant code
        /                                       # Prefix/suffix divider
        (?:
          # DOI suffix
          [^[:space:]]+;2-[\#0-9a-z]            # Early Wiley suffix
          |
          [^[:space:]]+                         # Suffix...
          \([^[:space:])]+\)                    # Ending in balanced parentheses...
          (?![^[:space:]\p{P}])                 # Not followed by more suffix
          |
          [^[:space:]]+(?![[:space:]])\p{^P}    # Suffix ending in non-punctuation
        )
        \.{0,3}                                 # Allow a DOI to end with up to 3 .
      )
    }x

    def self.extract(str, options = {})
      strict = options.fetch(:strict, false)

      dois = str.to_s.downcase.scan(REGEXP)
      dois = dois.map { |doi| doi.gsub(/\.+$/, '') } unless strict

      dois
    end
  end
end
