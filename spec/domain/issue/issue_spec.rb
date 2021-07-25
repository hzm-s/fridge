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

    describe 'Prepare acceptance criteria' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        issue.prepare_acceptance_criteria(criteria)
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

      before do
        issue.prepare_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.estimate(dev_role, StoryPoint.new(5))
      end

      it do
        expect { issue.assign_to_sprint(dev_role) }.to raise_error CanNotAssignToSprint
      end

      it do
        expect { issue.assign_to_sprint(po_role) }.to_not raise_error
      end

      it do
        expect { issue.assign_to_sprint(sm_role) }.to_not raise_error 
      end
    end

    describe 'to revert issue from sprint permission' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      before do
        issue.prepare_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.estimate(dev_role, StoryPoint.new(5))
        issue.assign_to_sprint(po_role)
      end

      it do
        expect { issue.revert_from_sprint(dev_role) }.to raise_error CanNotRevertFromSprint
      end

      it do
        expect { issue.revert_from_sprint(po_role) }.to_not raise_error
      end

      it do
        expect { issue.revert_from_sprint(sm_role) }.to_not raise_error 
      end
    end

    describe 'to update acceptance' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }
      let(:criteria) { acceptance_criteria(%w(CRT)) }

      before do
        issue.prepare_acceptance_criteria(criteria)
        issue.estimate(dev_role, StoryPoint.new(5))
        issue.assign_to_sprint(po_role)
      end

      it do
        expect { issue.update_acceptance(dev_role, criteria) }.to raise_error CanNotUpdateAccept
      end

      it do
        expect { issue.update_acceptance(po_role, criteria) }.to_not raise_error
      end

      it do
        expect { issue.update_acceptance(sm_role, criteria) }.to raise_error CanNotUpdateAccept
      end
    end

    describe 'Feature issue status' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      it do
        issue.modify_description(issue_description('NEW user story'))
        expect(issue.status).to eq Statuses::Preparation

        issue.prepare_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(issue.status).to eq Statuses::Preparation

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Preparation

        issue.prepare_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.assign_to_sprint(po_role)
        expect(issue.status).to eq Statuses::Wip

        issue.revert_from_sprint(po_role)
        expect(issue.status).to eq Statuses::Ready

        issue.assign_to_sprint(po_role)
        issue.update_acceptance(po_role, acceptance_criteria(%w(CRT), [1]))
        expect(issue.status).to eq Statuses::Accepted
      end
    end

    describe 'Task issue status' do
      let(:issue) { described_class.create(product_id, Types::Task, description) }

      it do
        expect(issue.status).to eq Statuses::Ready

        issue.modify_description(issue_description('NEW task'))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.unknown)
        expect(issue.status).to eq Statuses::Ready

        issue.assign_to_sprint(po_role)
        expect(issue.status).to eq Statuses::Wip

        issue.revert_from_sprint(po_role)
        expect(issue.status).to eq Statuses::Ready

        issue.assign_to_sprint(po_role)
        issue.update_acceptance(po_role, acceptance_criteria(%w(CRT), [1]))
        expect(issue.status).to eq Statuses::Accepted
      end
    end
  end
end
