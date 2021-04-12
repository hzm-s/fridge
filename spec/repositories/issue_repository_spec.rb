# typed: false
require 'rails_helper'

RSpec.describe IssueRepository::AR do
  let!(:product) { create_product }
  let(:dev_role) { team_roles(:dev) }

  describe 'Add' do
    it do
      issue = Issue::Issue.create(product.id, Issue::Types::Feature, Issue::Description.new('ABC'))

      expect { described_class.store(issue) }
        .to change { Dao::Issue.count }.by(1)
        .and change { Dao::AcceptanceCriterion.count }.by(0)

      aggregate_failures do
        rel = Dao::Issue.last
        expect(rel.id).to eq issue.id.to_s
        expect(rel.dao_product_id).to eq issue.product_id.to_s
        expect(rel.issue_type).to eq issue.type.to_s
        expect(rel.status).to eq issue.status.to_s
        expect(rel.description).to eq issue.description.to_s
        expect(rel.size).to be_nil
      end
    end
  end

  describe 'Update' do
    it do
      issue = plan_issue(product.id)
      issue.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2)))

      expect { described_class.store(issue) }
        .to change { Dao::Issue.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(2)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2).to_a)
    end

    it do
      issue = plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3 AC4))
      issue.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))

      expect { described_class.store(issue) }
        .to change { Dao::Issue.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2 AC3).to_a)
    end

    it do
      issue = plan_issue(product.id, acceptance_criteria: %w(ac1))
      issue.estimate(dev_role, Issue::StoryPoint.new(5))

      described_class.store(issue)
      updated = described_class.find_by_id(issue.id)

      expect(updated.status).to eq issue.status
    end
  end

  describe 'Remove' do
    it do
      issue = plan_issue(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

      expect { described_class.remove(issue.id) }
        .to change { Dao::Issue.count }.by(-1)
        .and change { Dao::AcceptanceCriterion.count }.by(-3)
    end
  end
end
