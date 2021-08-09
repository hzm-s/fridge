# typed: false
require 'rails_helper'

RSpec.describe RevertIssueFromSprintUsecase do
  let!(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:issue_b) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:issue_d) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, issue_b.id)

    stored_sprint = SprintRepository::AR.current(product.id)
    stored_issue_a = IssueRepository::AR.find_by_id(issue_a.id)
    stored_issue_b = IssueRepository::AR.find_by_id(issue_b.id)
    stored_issue_c = IssueRepository::AR.find_by_id(issue_c.id)

    aggregate_failures do
      expect(stored_sprint.issues).to eq issue_list(issue_a.id, issue_c.id)
      expect(stored_issue_a.status).to be Issue::Statuses::Wip
      expect(stored_issue_b.status).to be Issue::Statuses::Ready
      expect(stored_issue_c.status).to be Issue::Statuses::Wip
    end
  end

  it '着手していないアイテムは取り消しできないこと' do
    expect { described_class.perform(product.id, roles, issue_d.id) }
      .to raise_error(Issue::CanNotRevertFromSprint)
  end

  it '受け入れ済みアイテムは取り消しできないこと' do
    accept_issue(issue_a)
    expect { described_class.perform(product.id, roles, issue_a.id) }
      .to raise_error(Issue::AlreadyAccepted)
  end

  it 'スプリントが終了している場合は取り消しできないこと' do
    SprintRepository::AR.current(product.id).tap do |sprint|
      sprint.finish
      SprintRepository::AR.store(sprint)
    end

    expect {
      described_class.perform(product.id, roles, issue_c.id)
    }.to raise_error Sprint::NotStarted
  end
end
