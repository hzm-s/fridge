# typed: false
require 'rails_helper'

RSpec.describe ModifyIssueUsecase do
  let!(:product) { create_product }

  it do
    issue = plan_issue(product.id, 'ORIGINAL_DESCRIPTION')

    described_class.perform(issue.id, l_sentence('NEW_DESCRIPTION'))

    stored = IssueRepository::AR.find_by_id(issue.id)
    expect(stored.description.to_s).to eq 'NEW_DESCRIPTION'
  end
end
