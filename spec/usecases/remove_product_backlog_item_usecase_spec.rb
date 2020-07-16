require 'rails_helper'

RSpec.describe RemoveProductBacklogItemUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    described_class.perform(pbi.id)

    expect { ProductBacklogItemRepository::AR.find_by_id(pbi.id) }
      .to raise_error(Shared::DomainError)
  end
end
