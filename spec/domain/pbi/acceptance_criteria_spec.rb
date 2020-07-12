require 'rails_helper'

module Pbi
  RSpec.describe AcceptanceCriteria do
    describe '.create' do
      it do
        ac = described_class.create
        expect(ac.to_a).to be_empty
      end
    end

    describe '#add' do
      it do
        ac = described_class.create

        ac.add('AC_1')
        ac.add('AC_2')
        ac.add('AC_3')

        expect(ac.to_a).to eq [
          { no: 1, content: 'AC_1' },
          { no: 2, content: 'AC_2' },
          { no: 3, content: 'AC_3' },
        ]
      end
    end

    describe '#remove' do
      it do
        ac = described_class.create
        ac.add('AC_1')
        ac.add('AC_2')
        ac.add('AC_3')

        ac.remove(2)

        expect(ac.to_a).to eq [
          { no: 1, content: 'AC_1' },
          { no: 3, content: 'AC_3' },
        ]
      end
    end
  end
end
