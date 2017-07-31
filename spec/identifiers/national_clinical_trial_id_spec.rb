require 'identifiers/national_clinical_trial_id'

RSpec.describe Identifiers::NationalClinicalTrialId do
  it 'extract NCT IDs' do
    expect(described_class.extract("NCT00000106\nNCT00000107")).to contain_exactly('NCT00000106', 'NCT00000107')
  end

  it 'normalizes NCT IDs' do
    expect(described_class.extract("nct00000106\nnCt00000107")).to contain_exactly('NCT00000106', 'NCT00000107')
  end

  it 'does not match anything with empty arguments' do
    expect(described_class.extract(nil)).to be_empty
  end
end
