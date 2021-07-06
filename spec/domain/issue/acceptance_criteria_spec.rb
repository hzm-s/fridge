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
  end
end
