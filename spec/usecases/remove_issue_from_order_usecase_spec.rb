# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueFromOrderUsecase do
  let(:product) { create_product }
  let(:issue) { add_issue(product.id) }

  it do
    described_class.perform(product.id, issue.id)

    order = OrderRepository::AR.find_by_product_id(product.id)

    expect(order.issues).to eq Order::IssueList.new([])
  end
end
