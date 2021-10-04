# typed: false
require 'domain_helper'

module Work
  RSpec.describe Acceptance do
    describe 'Satisfy' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      it do
        a = described_class.new(criteria, [].to_set)
        expect(a.satisfy(2)).to eq described_class.new(criteria, [2].to_set)
      end

      it do
        a = described_class.new(criteria, [].to_set)
        expect { a.satisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end

      it do
        a = described_class.new(criteria, [1, 2].to_set)
        expect { a.satisfy(1) }.to raise_error AlreadySatisfied
      end
    end

    describe 'Dissatisfy' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      it do
        a = described_class.new(criteria, [1, 2, 3].to_set)
        expect(a.dissatisfy(2)).to eq described_class.new(criteria, [1, 3].to_set)
      end

      it do
        a = described_class.new(criteria, [1, 2, 3].to_set)
        expect { a.dissatisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end

      it do
        a = described_class.new(criteria, [3].to_set)
        expect { a.dissatisfy(1) }.to raise_error NotSatisfied
      end
    end

    describe 'Query to all satisfied' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }
      let(:empty_criteria) { acceptance_criteria([]) }

      context 'criteira = any, all satisfied = no' do
        it do
          a = described_class.new(criteria, [1, 3].to_set)
          expect(a).to_not be_all_satisfied
        end
      end

      context 'criteria = any, all satisfied = yes' do
        it do
          a = described_class.new(criteria, [1, 2, 3].to_set)
          expect(a).to be_all_satisfied
        end
      end

      context 'criteria = empty' do
        it do
          a = described_class.new(acceptance_criteria([]), [].to_set)
          expect(a).to be_all_satisfied
        end
      end
    end
  end
end
