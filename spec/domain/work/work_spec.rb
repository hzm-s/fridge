# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    let(:issue) do
      Issue::Issue.create(Product::Id.create, Issue::Types::Feature, l_sentence('DESC')).tap do |i|
        i.prepare_acceptance_criteria(criteria)
        i.estimate(team_roles(:dev), Issue::StoryPoint.new(5))
      end
    end
    let(:criteria) { acceptance_criteria(%w(CRT)) }

    describe 'Create' do
      it do
        work = described_class.create(issue)

        aggregate_failures do
          expect(work.issue_id).to eq issue.id
          expect(work.status).to eq Statuses.initial(issue.type, issue.acceptance_criteria)
          expect(work.tasks).to be_empty
        end
      end
    end

    describe 'Update tasks' do
      let(:work) { described_class.create(issue) }

      it do
        tasks = TaskList.new
          .append(s_sentence('Task_1'))
          .append(s_sentence('Task_2'))
          .append(s_sentence('Task_3'))

        work.update_tasks(tasks)

        expect(work.tasks).to eq tasks
      end
    end

    describe 'Update acceptance' do
      let(:work) { described_class.create(issue) }

      it do
        acceptance = Acceptance.new(issue.acceptance_criteria, [1].to_set)
        work.update_acceptance(acceptance)
        expect(work.acceptance).to eq acceptance
      end
    end

    describe 'Status' do
      let(:work) { described_class.create(issue) }
      let(:all_satisfied) { Acceptance.new(issue.acceptance_criteria, [1].to_set) }
      let(:not_all_satisfied) { Acceptance.new(issue.acceptance_criteria, [].to_set) }

      it do
        aggregate_failures do
          work.update_acceptance(all_satisfied)
          expect(work.status).to eq Statuses::Acceptable.new(issue.type)

          work.update_acceptance(not_all_satisfied)
          expect(work.status).to eq Statuses::NotAccepted.new(issue.type)
        end
      end
    end
  end
end
