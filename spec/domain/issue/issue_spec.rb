# typed: false
require 'domain_helper'

module Issue
  RSpec.describe Issue do
    let(:product_id) { Product::Id.create }
    let(:description) { issue_description('A user story') }

    describe 'create' do
      let(:issue) { described_class.create(product_id, description) }

      it do
        aggregate_failures do
          expect(issue.id).to_not be_nil
          expect(issue.product_id).to eq product_id
          expect(issue.status).to eq Statuses::Preparation
          expect(issue.description).to eq description
          expect(issue.size).to eq StoryPoint.unknown
          expect(issue.acceptance_criteria).to be_empty
        end
      end
    end

    describe 'Modify description' do
      let(:issue) { described_class.create(product_id, issue_description('Origin')) }

      it do
        new_desc = issue_description('Modified')
        issue.modify_description(new_desc)
        expect(issue.description).to eq new_desc
      end
    end

    describe 'Acceptance criteria' do
      let(:issue) { described_class.create(product_id, description) }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        issue.update_acceptance_criteria(criteria)
        expect(issue.acceptance_criteria).to eq criteria
      end
    end

    describe 'Update Status' do
      let(:issue) { described_class.create(product_id, description) }

      it do
        issue.modify_description(issue_description('NEW user story'))
        expect(issue.status).to eq Statuses::Preparation

        issue.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(issue.status).to eq Statuses::Preparation

        issue.estimate(StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.update_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Preparation
      end
    end
  end
end
