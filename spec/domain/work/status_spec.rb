# typed: false
require 'domain_helper'

module Work
  RSpec.describe Status do
    describe 'Not accepted' do
      xit do
        status = described_class::NotAccepted
        expect(status.available_activities).to eq activity_set([])
      end
    end
  end
end
