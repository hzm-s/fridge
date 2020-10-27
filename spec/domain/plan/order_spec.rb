# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Order do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Append & Remove' do
      it do
        order = described_class.new([])
        order = order.append(issue_a)
        order = order.append(issue_b)
        order = order.append(issue_c)

        expect(order.to_a).to eq [issue_a, issue_b, issue_c]
      end

      it do
        order = described_class.new([issue_a, issue_b, issue_c])

        order = order.remove(issue_b)

        expect(order.to_a).to eq [issue_a, issue_c]
      end
    end

    describe 'Empty?' do
      it do
        expect(described_class.new([])).to be_empty
      end

      it do
        expect(described_class.new([issue_a])).to_not be_empty
      end
    end

    describe 'Swap' do
      before do
        @order = described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])
      end

      it do
        @order = @order.swap(issue_a, issue_a)
        expect(@order.to_a).to eq [issue_a, issue_b, issue_c, issue_d, issue_e]
      end

      it do
        @order = @order.swap(issue_c, issue_b)
        expect(@order.to_a).to eq [issue_a, issue_c, issue_b, issue_d, issue_e]
      end

      it do
        @order = @order.swap(issue_e, issue_a)
        expect(@order.to_a).to eq [issue_e, issue_a, issue_b, issue_c, issue_d]
      end

      it do
        @order = @order.swap(issue_c, issue_d)
        expect(@order.to_a).to eq [issue_a, issue_b, issue_d, issue_c, issue_e]
      end

      it do
        @order = @order.swap(issue_a, issue_e)
        expect(@order.to_a).to eq [issue_b, issue_c, issue_d, issue_e, issue_a]
      end
    end

    describe '#subset' do
      it do
        order = described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])

        aggregate_failures do
          expect(order.subset(nil, issue_b)).to eq [issue_a, issue_b]
          expect(order.subset(issue_a, issue_d)).to eq [issue_b, issue_c, issue_d]
        end
      end
    end
  end
end
