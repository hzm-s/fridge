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
    let(:all_satisfied) { Acceptance.new(issue.acceptance_criteria, [1].to_set) }
    let(:not_all_satisfied) { Acceptance.new(issue.acceptance_criteria, [].to_set) }

    describe 'Create' do
      it do
        work = described_class.create(issue)

        aggregate_failures do
          expect(work.issue_id).to eq issue.id
          expect(work.status).to eq Statuses.initial(issue.acceptance_criteria)
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
        work.update_acceptance(all_satisfied)
        expect(work.acceptance).to eq all_satisfied
      end
    end

    describe 'Accept' do
      let(:work) { described_class.create(issue) }

      before { work.update_acceptance(all_satisfied) }

      it do
        work.accept
        expect(work.status).to eq Statuses.from_string('accepted')
      end
    end

    describe 'Status' do
      let(:work) { described_class.create(issue) }

      it do
        aggregate_failures do
          work.update_acceptance(all_satisfied)
          expect(work.status).to eq Statuses.from_string('acceptable')

          work.update_acceptance(not_all_satisfied)
          expect(work.status).to eq Statuses.from_string('not_accepted')
        end
      end
    end
  end
end
