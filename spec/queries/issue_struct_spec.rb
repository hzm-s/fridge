# typed: false
require 'rails_helper'

RSpec.describe IssueStruct do
  let!(:product) { create_product }

  it '受け入れ基準がある場合は受け入れ基準を含むこと' do
    add_issue(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

    s = described_class.new(Dao::Issue.last)

    expect(s.criteria.map(&:content)).to eq %w(ac1 ac2 ac3) 
  end

  it 'タイプを返すこと' do
    issue = add_issue(product.id, type: Issue::Types::Task)

    s = described_class.new(Dao::Issue.last)

    aggregate_failures do
      expect(s.status).to eq issue.status
      expect(s).to_not be_can_estimate
    end
  end

  it 'ステータスを返すこと' do
    issue = add_issue(product.id)

    s = described_class.new(Dao::Issue.last)

    expect(s.status).to eq issue.status
  end
end
