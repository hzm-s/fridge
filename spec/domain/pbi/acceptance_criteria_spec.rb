# typed: false
require 'domain_helper'

module Pbi
  describe AcceptanceCriteria do
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
           .append(s_sentence('AC_A'))
           .append(s_sentence('AC_B'))
           .remove(2)
           .append(s_sentence('AC_B'))
           .append(s_sentence('AC_C'))

        expect(criteria.to_a_with_number).to eq [
          [1, 'AC_A'],
          [2, 'AC_B'],
          [3, 'AC_C'],
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

        expect(modified.to_a_with_number).to eq [
          [1, 'AC1'],
          [2, 'Modified AC2'],
          [3, 'AC3'],
        ]
      end
    end
  end
end
