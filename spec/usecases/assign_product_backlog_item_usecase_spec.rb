# typed: false
require 'rails_helper'

RSpec.describe AssignProductBacklogItemUsecase do
  let(:product) { create_product }
  let(:pbi) { add_pbi(product.id, acceptance_criteria: %w(ac1), size: 3) }

  it do
    described_class.perform(pbi.id)
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
    expect(updated.status).to eq Pbi::Statuses::Todo
  end
end
