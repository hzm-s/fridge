require 'rails_helper'

module Pbi
  RSpec.describe AcceptanceCriteria do
    describe '.create' do
      it do
        ac = described_class.create
        expect(ac).to be_empty
      end
    end

    describe '#add' do
      it do
        ac = described_class.create

        ac.add('AC_1')
        ac.add('AC_2')
        ac.add('AC_3')

        expect(ac.to_a).to eq %w(AC_1 AC_2 AC_3)
      end
    end

    describe '#remove' do
      it do
        ac = described_class.create
        ac.add('AC_1')
        ac.add('AC_2')
        ac.add('AC_3')

        ac.remove(2)

        expect(ac.to_a).to eq %w(AC_1 AC_3)
      end
    end
  end
end
