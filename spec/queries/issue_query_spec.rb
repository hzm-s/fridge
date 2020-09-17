# typed: false
require 'rails_helper'

RSpec.describe IssueQuery do
  let!(:product) { create_product }

  it 'ステータスを返すこと' do
    issue = add_issue(product.id, acceptance_criteria: %w(ac1))

    stored = described_class.call(issue.id.to_s)
    expect(stored.status).to eq Issue::Statuses::Preparation
  end
end
