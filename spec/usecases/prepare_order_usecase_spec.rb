# typed: false
require 'rails_helper'

RSpec.describe PrepareOrderUsecase do
  let(:product) { create_product }

  it do
    described_class.perform(product.id)

    order = OrderRepository::AR.find_by_product_id(product.id)
    expect(order.issues).to be_empty
  end
end
