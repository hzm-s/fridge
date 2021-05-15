# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    describe 'Create' do
      it do
        issue_id = Issue::Id.create
        work = described_class.create(issue_id)

        aggregate_failures do
          expect(work.issue_id).to eq issue_id
          expect(work.tasks).to be_empty
        end
      end
    end
  end
end
