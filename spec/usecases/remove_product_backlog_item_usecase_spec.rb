# typed: false
require 'rails_helper'

RSpec.describe RemoveProductBacklogItemUsecase do
  let!(:product) { create_product }
  let!(:ex_pbi) { add_pbi(product.id) }

  it do
    pbi = add_pbi(product.id)
    described_class.perform(pbi.id)

    expect { ProductBacklogItemRepository::AR.find_by_id(pbi.id) }
      .to raise_error(ActiveRecord::RecordNotFound)

    release = ReleaseRepository::AR.find_last_by_product_id(pbi.product_id)
    expect(release.items).to match_array [ex_pbi.id]
  end

  it do
    assigned_pbi = add_pbi(product.id, acceptance_criteria: %w(criterion), size: 8, assigned: true)

    expect { described_class.perform(assigned_pbi.id) }
      .to raise_error(Pbi::ItemCanNotRemove)
  end
end
