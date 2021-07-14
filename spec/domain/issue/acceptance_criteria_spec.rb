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
        target.modify_content('Modified AC2')
        criteria.update(target)

        aggregate_failures do
          expect(criteria.of(1).content).to eq 'AC1'
          expect(criteria.of(2).content).to eq 'Modified AC2'
          expect(criteria.of(3).content).to eq 'AC3'
          expect(criteria.to_a.map(&:number)).to eq [1, 2, 3]
        end
      end
    end
  end
end
