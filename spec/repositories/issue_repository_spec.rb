# typed: false
require 'rails_helper'

RSpec.describe IssueRepository::AR do
  let!(:product) { create_product }

  describe 'Add' do
    it do
      issue = Issue::Issue.create(product.id, Issue::Types::Feature, l_sentence('ABC'))

      expect { described_class.store(issue) }
        .to change { Dao::Issue.count }.by(1)
        .and change { Dao::AcceptanceCriterion.count }.by(0)

      aggregate_failures do
        dao = Dao::Issue.last
        expect(dao.id).to eq issue.id.to_s
        expect(dao.dao_product_id).to eq issue.product_id.to_s
        expect(dao.issue_type).to eq issue.type.to_s
        expect(dao.status).to eq issue.status.to_s
        expect(dao.description).to eq issue.description.to_s
        expect(dao.size).to be_nil
      end
    end
  end

  describe 'Update' do
    let(:issue) { Issue::Issue.create(product.id, Issue::Types::Feature, l_sentence('ABC')) }

    before { described_class.store(issue) }

    it do
      criteria = acceptance_criteria(%w(AC1 AC2 AC3 AC4))
      issue.prepare_acceptance_criteria(criteria)
      described_class.store(issue)

      issue.prepare_acceptance_criteria(criteria.remove(4))

      expect { described_class.store(issue) }
        .to change { Dao::Issue.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)

      aggregate_failures do
        dao = Dao::AcceptanceCriterion.all
        expect(dao.size).to eq 3
        expect(dao[0].content).to eq 'AC1'
        expect(dao[1].content).to eq 'AC2'
        expect(dao[2].content).to eq 'AC3'
      end
    end

    it do
      issue.prepare_acceptance_criteria(acceptance_criteria(%w(CRT)))
      issue.estimate(team_roles(:dev), Issue::StoryPoint.new(5))

      described_class.store(issue)
      updated = described_class.find_by_id(issue.id)

      expect(updated.status).to eq issue.status
    end
  end

  describe 'Remove' do
    it do
      issue = Issue::Issue.create(product.id, Issue::Types::Feature, l_sentence('ABC'))
      issue.prepare_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))
      described_class.store(issue)

      described_class.remove(issue.id)

      aggregate_failures do
        expect(Dao::Issue.find_by(id: issue.id.to_s)).to be_nil
        expect(Dao::AcceptanceCriterion.where(dao_issue_id: issue.id.to_s)).to be_empty
      end
    end
  end
end
