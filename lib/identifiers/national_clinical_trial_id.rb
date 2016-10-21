module Identifiers
  class NationalClinicalTrialId
    def self.extract(str)
      str.scan(/\bNCT\d+\b/i).map(&:upcase)
    end
  end
end
