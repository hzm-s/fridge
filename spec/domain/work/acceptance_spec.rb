# typed: false
require 'domain_helper'

module Work
  RSpec.describe Acceptance do
    let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

    describe 'Satisfy' do
      it do
        type = Issue::Types::Feature
        a = described_class.new(type, criteria, [].to_set)
        expect(a.satisfy(2)).to eq described_class.new(type, criteria, [2].to_set)
      end

      it do
        a = described_class.new(Issue::Types::Feature, criteria, [].to_set)
        expect { a.satisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end
    end

    describe 'Dissatisfy' do
      it do
        type = Issue::Types::Feature
        a = described_class.new(type, criteria, [1, 2, 3].to_set)
        expect(a.dissatisfy(2)).to eq described_class.new(type, criteria, [1, 3].to_set)
      end

      xit do
        a = described_class.new(Issue::Types::Feature, criteria, [].to_set)
        expect { a.satisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end
    end
  end
end
