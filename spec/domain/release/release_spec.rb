# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        release = described_class.create(product_id, 'MVP')

        aggregate_failures do
          expect(release.id).to_not be_nil
          expect(release.product_id).to eq product_id
          expect(release.title).to eq 'MVP'
        end
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.create(product_id, 'OLD_TITLE')

        release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
      end
    end
  end
end
