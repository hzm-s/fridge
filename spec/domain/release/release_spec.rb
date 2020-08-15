# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    it do
      repository = double(:repository, next_no: 1).tap do |r|
        r.extend ReleaseRepository
      end

      release = described_class.create(repository, 'MVP')

      expect(release.no).to eq 1
      expect(release.title).to eq 'MVP'
      expect(release.items).to be_empty
    end
  end
end
