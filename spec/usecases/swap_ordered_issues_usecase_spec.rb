# typed: false
require 'rails_helper'

RSpec.describe SwapOrderedIssuesUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) } 
  let!(:issue_b) { add_issue(product.id) } 
  let!(:issue_c) { add_issue(product.id) } 

  it do
    described_class.perform(product.id, issue_a.id, 2)

    order = OrderRepository::AR.find_by_product_id(product.id)

    expect(order.issues).to eq Order::IssueList.new([issue_b.id, issue_c.id, issue_a.id])
  end
end
