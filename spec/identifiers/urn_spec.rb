require 'identifiers/urn'

RSpec.describe Identifiers::URN do
  it 'extracts URNs' do
    str = 'En un pueblo italiano urn:1234:abc al pie de la montaña URN:foo:bar%23.\\'

    expect(described_class.extract(str)).to contain_exactly('urn:1234:abc', 'URN:foo:bar%23.')
  end
end
