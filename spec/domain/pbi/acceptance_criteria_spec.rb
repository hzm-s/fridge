require 'rails_helper'

module Pbi
  RSpec.describe AcceptanceCriteria do
    describe '.create' do
      it do
        ac = described_class.create
        expect(ac).to be_empty
      end
    end
  end
end
