# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    let(:pbi) do
      Pbi::Pbi.create(Product::Id.create, Pbi::Types::Feature, l_sentence('DESC')).tap do |i|
        i.prepare_acceptance_criteria(criteria)
        i.estimate(team_roles(:dev), Pbi::StoryPoint.new(5))
      end
    end
    let(:criteria) { acceptance_criteria(%w(CRT)) }
    let(:all_satisfied) { Acceptance.new(pbi.acceptance_criteria, [1].to_set) }
    let(:not_all_satisfied) { Acceptance.new(pbi.acceptance_criteria, [].to_set) }

    describe 'Create' do
      it do
        work = described_class.create(pbi)

        aggregate_failures do
          expect(work.pbi_id).to eq pbi.id
          expect(work.status).to eq Statuses.initial(pbi.acceptance_criteria)
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

      it do
        aggregate_failures do
          work.update_acceptance(all_satisfied)
          expect(work.status).to eq Statuses.from_string('acceptable')

          work.update_acceptance(not_all_satisfied)
          expect(work.status).to eq Statuses.from_string('not_accepted')
        end
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
  end
end
