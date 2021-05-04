# typed: false
require 'domain_helper'

module Issue
  RSpec.describe Issue do
    let(:product_id) { Product::Id.create }
    let(:description) { issue_description('A user story') }
    let(:dev_role) { team_roles(:dev) }
    let(:po_role) { team_roles(:po) }
    let(:sm_role) { team_roles(:sm) }

    describe 'Create' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        aggregate_failures do
          expect(issue.id).to_not be_nil
          expect(issue.product_id).to eq product_id
          expect(issue.type).to eq Types::Feature
          expect(issue.status).to eq Statuses::Preparation
          expect(issue.description).to eq description
          expect(issue.size).to eq StoryPoint.unknown
          expect(issue.acceptance_criteria).to be_empty
        end
      end
    end

    describe 'Modify description' do
      let(:issue) { described_class.create(product_id, Types::Feature, issue_description('Origin')) }

      it do
        new_desc = issue_description('Modified')
        issue.modify_description(new_desc)
        expect(issue.description).to eq new_desc
      end
    end

    describe 'Acceptance criteria' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        issue.update_acceptance_criteria(criteria)
        expect(issue.acceptance_criteria).to eq criteria
      end
    end

    describe 'estimation permission' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        expect { issue.estimate(dev_role, StoryPoint.new(2)) }.to_not raise_error 
      end

      it do
        expect { issue.estimate(po_role, StoryPoint.new(2)) }.to raise_error CanNotEstimate
      end

      it do
        expect { issue.estimate(sm_role, StoryPoint.new(2)) }.to raise_error CanNotEstimate
      end
    end

    describe 'to assign issue to sprint permission' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }
      let(:sprint_id) { Sprint::Id.create }

      before do
        issue.update_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.estimate(dev_role, StoryPoint.new(5))
      end

      it do
        expect { issue.assign_to_sprint(dev_role, sprint_id) }.to raise_error CanNotAssignToSprint
      end

      it do
        expect { issue.assign_to_sprint(po_role, sprint_id) }.to_not raise_error
      end

      it do
        expect { issue.assign_to_sprint(sm_role, sprint_id) }.to_not raise_error 
      end
    end

    describe 'Feature issue status' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        issue.modify_description(issue_description('NEW user story'))
        expect(issue.status).to eq Statuses::Preparation

        issue.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(issue.status).to eq Statuses::Preparation

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.update_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Preparation

        issue.update_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.assign_to_sprint(po_role, Sprint::Id.create)
        expect(issue.status).to eq Statuses::Wip
      end
    end

    describe 'Task issue status' do
      let(:issue) { described_class.create(product_id, Types::Task, description) }

      it do
        expect(issue.status).to eq Statuses::Ready

        issue.modify_description(issue_description('NEW task'))
        expect(issue.status).to eq Statuses::Ready

        issue.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.update_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.unknown)
        expect(issue.status).to eq Statuses::Ready

        issue.assign_to_sprint(po_role, Sprint::Id.create)
        expect(issue.status).to eq Statuses::Wip
      end
    end
  end
end
