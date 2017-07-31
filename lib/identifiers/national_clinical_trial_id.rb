module Identifiers
  class NationalClinicalTrialId
    def self.extract(str)
      str.to_s.scan(/\bNCT\d+\b/i).map(&:upcase)
    end
  end
end
