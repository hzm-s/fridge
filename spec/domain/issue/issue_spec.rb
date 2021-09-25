# typed: false
require 'domain_helper'

module Issue
  RSpec.describe Issue do
    let(:product_id) { Product::Id.create }
    let(:description) { l_sentence('A user story') }
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
      let(:issue) { described_class.create(product_id, Types::Feature, l_sentence('Origin')) }

      it do
        new_desc = l_sentence('Modified')
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

    describe 'to estimate issue permission' do
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

      it { expect { issue.assign_to_sprint(dev_role) }.to raise_error CanNotAssignToSprint }
      it { expect { issue.assign_to_sprint(po_role) }.to_not raise_error }
      it { expect { issue.assign_to_sprint(sm_role) }.to_not raise_error }
    end

    describe 'to revert issue from sprint permission' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }

      before do
        issue.prepare_acceptance_criteria(acceptance_criteria(%w(Criterion)))
        issue.estimate(dev_role, StoryPoint.new(5))
        issue.assign_to_sprint(po_role)
      end

      it { expect { issue.revert_from_sprint(dev_role) }.to raise_error CanNotRevertFromSprint }
      it { expect { issue.revert_from_sprint(po_role) }.to_not raise_error }
      it { expect { issue.revert_from_sprint(sm_role) }.to_not raise_error }
    end

    #describe 'to update acceptance permission' do
    #  context 'when Feature' do
    #    let(:issue) { described_class.create(product_id, Types::Feature, description) }
    #    let(:criteria) { acceptance_criteria(%w(CRT)) }

    #    before do
    #      issue.prepare_acceptance_criteria(criteria)
    #      issue.estimate(dev_role, StoryPoint.new(5))
    #      issue.assign_to_sprint(po_role)
    #    end

    #    it { expect { issue.update_acceptance(dev_role, criteria) }.to raise_error CanNotUpdateAcceptance }
    #    it { expect { issue.update_acceptance(po_role, criteria) }.to_not raise_error }
    #    it { expect { issue.update_acceptance(sm_role, criteria) }.to raise_error CanNotUpdateAcceptance }
    #  end

    #  context 'when Task' do
    #    let(:issue) { described_class.create(product_id, Types::Task, description) }
    #    let(:criteria) { acceptance_criteria(%w(CRT)) }

    #    before do
    #      issue.prepare_acceptance_criteria(criteria)
    #      issue.estimate(dev_role, StoryPoint.new(5))
    #      issue.assign_to_sprint(po_role)
    #    end

    #    it { expect { issue.update_acceptance(dev_role, criteria) }.to_not raise_error }
    #    it { expect { issue.update_acceptance(po_role, criteria) }.to_not raise_error }
    #    it { expect { issue.update_acceptance(sm_role, criteria) }.to raise_error CanNotUpdateAcceptance }
    #  end
    #end

    describe 'Feature issue status' do
      let(:issue) { described_class.create(product_id, Types::Feature, description) }
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      it do
        issue.modify_description(l_sentence('NEW user story'))
        expect(issue.status).to eq Statuses::Preparation

        issue.prepare_acceptance_criteria(criteria)
        expect(issue.status).to eq Statuses::Preparation

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(acceptance_criteria([]))
        expect(issue.status).to eq Statuses::Preparation

        issue.prepare_acceptance_criteria(criteria)
        issue.assign_to_sprint(po_role)
        expect(issue.status).to eq Statuses::Wip

        issue.revert_from_sprint(po_role)
        expect(issue.status).to eq Statuses::Ready
      end
    end

    describe 'Task issue status' do
      let(:issue) { described_class.create(product_id, Types::Task, description) }
      let(:criteria) { acceptance_criteria([]) }

      it do
        expect(issue.status).to eq Statuses::Ready

        issue.modify_description(l_sentence('NEW task'))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(criteria)
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.new(3))
        expect(issue.status).to eq Statuses::Ready

        issue.prepare_acceptance_criteria(criteria)
        expect(issue.status).to eq Statuses::Ready

        issue.estimate(dev_role, StoryPoint.unknown)
        expect(issue.status).to eq Statuses::Ready

        issue.assign_to_sprint(po_role)
        expect(issue.status).to eq Statuses::Wip

        issue.revert_from_sprint(po_role)
        expect(issue.status).to eq Statuses::Ready
      end
    end
  end
end
