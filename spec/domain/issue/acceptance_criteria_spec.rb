# typed: false
require 'domain_helper'

module Issue
  RSpec.describe AcceptanceCriteria do
    describe 'Create' do
      it do
        criteria = described_class.create
        expect(criteria).to be_empty
      end
    end

    describe 'Append and Remove' do
      it do
        criteria = described_class.create
        criteria.append('AC_A')
        criteria.remove(1)
        criteria.append('AC_A')
        criteria.append('AC_B')
        criteria.append('AC_C')
        criteria.append('AC_D')
        criteria.append('AC_E')
        criteria.remove(4)
        criteria.append('AC_F')

        aggregate_failures do
          expect(criteria.of(1).content).to eq 'AC_A'
          expect(criteria.of(2).content).to eq 'AC_B'
          expect(criteria.of(3).content).to eq 'AC_C'
          expect(criteria.of(5).content).to eq 'AC_E'
          expect(criteria.of(6).content).to eq 'AC_F'
        end
      end
    end

    describe 'Update' do
      it do
        criteria = described_class.create
        criteria.append('AC1')
        criteria.append('AC2')
        criteria.append('AC3')

        target = criteria.of(2)
        target.modify_content('Modified_AC2')
        criteria.update(target)

        target = criteria.of(3)
        target.satisfy
        criteria.update(target)

        aggregate_failures do
          updated = criteria.to_a
          expect(updated.size).to eq 3
          expect(updated.map(&:number)).to eq [1, 2, 3]
          expect(updated.map(&:content)).to eq %w(AC1 Modified_AC2 AC3)
          expect(updated.map(&:satisfied?)).to eq [false, false, true]
        end
      end
    end

    describe 'Query to all satisfied' do
      it do
        criteria = described_class.create
        criteria.append('AC1')
        criteria.append('AC2')
        criteria.append('AC3')

        criteria.update(criteria.of(2).tap { |c| c.satisfy })
        expect(criteria.satisfied?).to be false

        criteria.update(criteria.of(1).tap { |c| c.satisfy })
        expect(criteria.satisfied?).to be false

        criteria.update(criteria.of(3).tap { |c| c.satisfy })
        expect(criteria.satisfied?).to be true
      end
    end
  end
end
