# typed: false
require 'rails_helper'

module Plan
  RSpec.describe Plan do
    let(:product) { create_product }

    describe 'Create' do
      it do
        plan = described_class.create(product.id)

        expect(plan.release('Minimum').items).to be_empty
      end
    end
  end
end
