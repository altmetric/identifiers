module Identifiers
  class DOI
    def self.extract(str)
      most_dois = %r{\b10.\d{4,9}/[-._;()/:A-Z0-9]+\b}i
      old_wiley_dois = %r{^10.1002/[^\s]+}

      str.scan(Regexp.union([most_dois, old_wiley_dois])).map(&:downcase)
    end
  end
end
