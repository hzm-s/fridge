# typed: false
require 'rails_helper'

RSpec.describe IssueQuery do
  let!(:product) { create_product }
  let(:issue) { plan_issue(product.id, acceptance_criteria: %w(ac1)) }

  it do
    stored = described_class.call(issue.id.to_s)
    expect(stored.product_id).to eq issue.product_id.to_s
  end

  it do
    stored = described_class.call(issue.id.to_s)
    expect(stored.type).to eq issue.type
  end

  it do
    stored = described_class.call(issue.id.to_s)
    expect(stored.status).to eq issue.status
  end
end
