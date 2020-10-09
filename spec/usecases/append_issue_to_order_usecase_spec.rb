# typed: false
require 'rails_helper'

RSpec.describe AppendIssueToOrderUsecase do
  let(:product) { create_product }
  let(:issue) { Issue::Issue.create(product.id, Issue::Types::Feature, issue_description('DESC')) }

  it do
    described_class.perform(product.id, issue.id)

    order = OrderRepository::AR.find_by_product_id(product.id)

    expect(order.issues).to eq Order::IssueList.new([issue.id])
  end
end