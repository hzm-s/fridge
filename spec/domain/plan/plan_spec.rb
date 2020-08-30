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

    describe 'Add & Remove release' do
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
        expect(plan.release(1).title).to eq 'Phase1'
        expect(plan.release(2).title).to eq 'Phase2'
        expect(plan.release(3).title).to eq 'Phase3'
      end

      it do
        plan.remove_release(2)

        expect(plan.release(1).title).to eq 'Phase1'
        expect(plan.release(2).title).to eq 'Phase3'
      end

      it do
        release = plan.release(3)
        release.add_item(Pbi::Id.create)
        plan.replace_release(3, release)

        expect { plan.remove_release(3) }.to raise_error CanNotRemoveRelease
      end
    end

    describe 'Remove availability' do
      let(:plan) { described_class.create(product.id) }

      before do
        plan.add_release(Release.create('R1'))
      end

      it do
        expect(plan).to_not be_can_remove_release
        expect { plan.remove_release(1) }.to raise_error CanNotRemoveRelease
      end

      it do
        plan.add_release(Release.create('R2'))

        expect(plan).to be_can_remove_release
      end
    end

    describe 'Replace release' do
      let(:plan) { described_class.create(product.id) }

      it do
        release1 = Release.create('Phase1')
        release2 = Release.create('Phase2')
        release3 = Release.create('Phase3')

        plan.add_release(release1)
        plan.add_release(release2)
        plan.add_release(release3)

        release1.modify_title('MVP')
        plan.replace_release(1, release1)
        expect(plan.release(1).title).to eq 'MVP'
        expect(plan.release(2).title).to eq 'Phase2'
        expect(plan.release(3).title).to eq 'Phase3'
      end
    end

    describe 'Find release' do
      let(:plan) { described_class.create(product.id) }

      it do
        pbi_a = Pbi::Id.create
        pbi_b = Pbi::Id.create
        pbi_c = Pbi::Id.create

        release1 = Release.create('Phase1')
        release1.add_item(pbi_a)

        release2 = Release.create('Phase2')
        release2.add_item(pbi_b)

        release3 = Release.create('Phase3')
        release3.add_item(pbi_c)

        plan.add_release(release1)
        plan.add_release(release2)
        plan.add_release(release3)

        no = plan.find_release_no_by_item(pbi_b)

        expect(no).to eq 2
      end
    end
  end
end
