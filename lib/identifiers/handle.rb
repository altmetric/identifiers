module Identifiers
  class Handle
    RESOLVER_URL_QUERY_OR_FRAGMENT_REGEXP = %r{
      (https?://hdl\.handle\.net/[^\s?#]+)
      [?#]\S+
    }ix

    def self.extract(str)
      text = str.to_s.gsub(RESOLVER_URL_QUERY_OR_FRAGMENT_REGEXP, '\\1')
      text.scan(%r{\b[0-9.]+/[^[:space:]]+\b}i)
    end
  end
end
