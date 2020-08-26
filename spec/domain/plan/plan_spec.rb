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

    describe 'Add Release' do
      let(:plan) { described_class.create(product.id) }

      it do
        release2 = Release.create('Phase2')
        release3 = Release.create('Phase3')

        plan.add_release(release2)
        plan.add_release(release3)

        expect(plan.releases.map(&:title)).to eq %w(Minimum Phase2 Phase3)
      end
    end
  end
end
