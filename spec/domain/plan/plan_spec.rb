# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        aggregate_failures do
          expect(plan.product_id).to eq product_id
          expect(plan.releases.map(&:number)).to match_array [1]
        end
      end
    end
  end
end
