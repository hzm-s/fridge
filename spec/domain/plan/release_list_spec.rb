# typed: false
require 'domain_helper'

module Plan
  RSpec.describe ReleaseList do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }
    let(:issue_f) { Issue::Id.create }
    let(:issue_g) { Issue::Id.create }
    let(:issue_h) { Issue::Id.create }

    let(:order) do
      Order.new([issue_a, issue_b, issue_c, issue_d, issue_e, issue_f, issue_g, issue_h])
    end

    describe 'Add release' do
      it do
        list = described_class.new([])
        list = list.add('MVP', issue_c)
        expect(list.describe(order)).to eq ({
          'MVP' => [issue_a, issue_b, issue_c],
          nil => [issue_d, issue_e, issue_f, issue_g, issue_h]
        })
      end
    end
  end
end
