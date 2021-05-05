# typed: false
require 'domain_helper'

module Sprint
  RSpec.describe Sprint do
    let(:product_id) { Product::Id.create }

    describe 'Start' do
      it do
        sprint = described_class.start(product_id, 55)

        aggregate_failures do
          expect(sprint.id).to_not be_nil
          expect(sprint.product_id).to eq product_id
          expect(sprint.number).to eq 55
          expect(sprint).to_not be_finished
        end
      end
    end

    describe 'Finish' do
      it do
        sprint = described_class.start(product_id, 1)
        sprint.finish

        aggregate_failures do
          expect(sprint).to be_finished
          expect { sprint.finish }.to raise_error AlreadyFinished
        end
      end
    end

    describe 'Append issue' do
      let(:issue_a) { Issue::Id.create }
      let(:issue_b) { Issue::Id.create }
      let(:issue_c) { Issue::Id.create }

      it do
        sprint = described_class.start(product_id, 1)
        sprint.append_issue(issue_b)
        expect(sprint.issues).to eq issue_list(issue_b)
      end
    end
  end
end
