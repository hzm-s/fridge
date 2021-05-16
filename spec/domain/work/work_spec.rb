# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    let(:issue_id) { Issue::Id.create }

    describe 'Create' do
      it do
        work = described_class.create(issue_id)

        aggregate_failures do
          expect(work.issue_id).to eq issue_id
          expect(work.tasks).to be_empty
        end
      end
    end

    let(:work) { described_class.create(issue_id) }

    describe 'Append task' do
      it do
        work.append_task('Design API')
        work.append_task('Impl FE')
        work.append_task('Impl BE')

        aggregate_failures do
          expect(work.task_of(1).content).to eq 'Design API'
          expect(work.task_of(2).content).to eq 'Impl FE'
          expect(work.task_of(3).content).to eq 'Impl BE'
        end
      end
    end
  end
end
