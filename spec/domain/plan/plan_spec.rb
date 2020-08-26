# typed: false
require 'rails_helper'

module Plan
  RSpec.describe Plan do
    let(:product) { create_product }

    describe 'Create' do
      it do
        plan = described_class.create(product.id)

        expect(plan.releases).to be_empty
      end
    end

    describe 'Add & Remove Release' do
      let(:plan) { described_class.create(product.id) }

      before do
        release1 = Release.create('Phase1')
        release2 = Release.create('Phase2')
        release3 = Release.create('Phase3')

        plan.add_release(release1)
        plan.add_release(release2)
        plan.add_release(release3)
      end

      it do
        expect(plan.releases.map(&:title)).to eq %w(Phase1 Phase2 Phase3)
      end

      it do
        plan.remove_release('Phase2')

        expect(plan.releases.map(&:title)).to eq %w(Phase1 Phase3)
      end
    end
  end
end
