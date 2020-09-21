# typed: false
require 'rails_helper'

RSpec.describe IssueQuery do
  let!(:product) { create_product }
  let(:issue) { add_issue(product.id, type: :task, acceptance_criteria: %w(ac1)) }

  it 'タイプを返すこと' do
    stored = described_class.call(issue.id.to_s)
    expect(stored.type).to eq Issue::Types::Task
  end

  it 'ステータスを返すこと' do
    stored = described_class.call(issue.id.to_s)
    expect(stored.status).to eq Issue::Statuses::Preparation
  end
end
