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
  end
end
