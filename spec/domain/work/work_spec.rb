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
          expect(work.acceptance.status).to eq Status::NotAccepted
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

    describe 'Status' do
      let(:work) { described_class.create(issue) }

      it do
        aggregate_failures do
          work.satisfy_acceptance_criterion(1)
          expect(work.acceptance.status).to eq Status::Acceptable

          work.dissatisfy_acceptance_criterion(1)
          expect(work.acceptance.status).to eq Status::NotAccepted
        end
      end
    end
  end
end
