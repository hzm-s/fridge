# typed: false
require 'domain_helper'

module Requirement
  RSpec.describe Requirement do
    describe '.create' do
      it do
        requirement = described_class.create(Kinds::Feature, 'Yohkyu')

        aggregate_failures do
          expect(requirement.id).to_not be_nil
          expect(requirement.kind).to eq Kinds::Feature
          expect(requirement.description).to eq 'Yohkyu'
        end
      end
    end
  end
end
