# typed: false
require 'domain_helper'

module Work
  RSpec.describe Statuses do
    describe '.initial' do
      let(:criteria) { acceptance_criteria(%w(CRT)) }

      context 'criteria is NOT empty' do
        it do
          s = described_class.initial(criteria)
          expect(s).to eq Statuses.from_string('not_accepted')
        end
      end

      context 'criteria is empty' do
        it do
          s = described_class.initial(acceptance_criteria([]))
          expect(s).to eq Statuses.from_string('acceptable')
        end
      end
    end
  end
end
