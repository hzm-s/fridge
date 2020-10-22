# typed: false
require 'domain_helper'

module Plan
  RSpec.describe ScopeMap do
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

    describe 'Register scope' do
      it do
        map = described_class.new([])
        map = map.register('MVP', issue_c)
        expect(map.to_releases(order)).to eq [
          Release.new('MVP', [issue_a, issue_b, issue_c]),
          Release.new(nil, [issue_d, issue_e, issue_f, issue_g, issue_h]),
        ]
      end

      xit do
        map = described_class.new([Scope.new('Ph1', issue_c)])
        map = map.register('Ph2', issue_e, order)
        expect(map.to_releases(order)).to eq [
          Release.new('Ph1', [issue_a, issue_b, issue_c]),
          Release.new('Ph2', [issue_d, issue_e]),
          Release.new(nil, [issue_f, issue_g, issue_h]),
        ]
      end
    end

    xdescribe 'Deregister scope' do
      it do
        map = described_class.new([])
        map = map.register('MVP', issue_c)
        map = map.deregister('MVP')
        expect(map.to_releases(order)).to eq [
          Release.new(nil, [issue_a, issue_b, issue_c, issue_d, issue_e, issue_f, issue_g, issue_h])
          # リリーススコープ外は本当に必要?
        ]
      end
    end
  end
end
