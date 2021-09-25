# typed: false
require 'domain_helper'

module Issue
  RSpec.describe AcceptanceCriteria do
    describe 'Create' do
      it do
        criteria = described_class.new
        expect(criteria).to be_empty
      end
    end

    describe 'Append and Remove criterion' do
      it do
        criteria =
          described_class.new
           .then { |c| c.append(s_sentence('AC_A')) }
           .then { |c| c.remove(1) }
           .then { |c| c.append(s_sentence('AC_A')) }
           .then { |c| c.append(s_sentence('AC_B')) }
           .then { |c| c.append(s_sentence('AC_C')) }
           .then { |c| c.append(s_sentence('AC_D')) }
           .then { |c| c.append(s_sentence('AC_E')) }
           .then { |c| c.remove(4) }
           .then { |c| c.append(s_sentence('AC_F')) }

        expect(criteria.to_a).to eq [
          'AC_A',
          'AC_B',
          'AC_C',
          'AC_E',
          'AC_F',
        ]
      end
    end

    describe 'Modify content' do
      it do
        criteria = described_class.new([
          s_sentence('AC1'),
          s_sentence('AC2'),
          s_sentence('AC3'),
        ])

        modified = criteria.modify(2, s_sentence('Modified AC2'))

        expect(modified.to_a).to eq [
          'AC1',
          'Modified AC2',
          'AC3',
        ]
      end
    end
  end
end
