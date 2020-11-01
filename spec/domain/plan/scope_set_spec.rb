# typed: false
require 'domain_helper'

module Plan
  RSpec.describe ScopeSet do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }
    let(:order) { Order.new([issue_a, issue_b, issue_c, issue_d, issue_e]) }

    describe 'Add scope' do
      it do
        set = described_class.new
        set = set.add('Ph1', issue_b, order)
        expect(set).to eq described_class.new([Scope.new('Ph1', issue_b)])
      end

      it do
        set = described_class.new([Scope.new('Ph1', issue_b)])
        set = set.add('Ph2', issue_d, order)
        expect(set).to eq described_class.new([Scope.new('Ph1', issue_b), Scope.new('Ph2', issue_d)])
      end

      it do
        set = described_class.new([Scope.new('TMP', issue_e)])
        set = set.add('MVP', issue_c, order)
        expect(set).to eq described_class.new([Scope.new('MVP', issue_c), Scope.new('TMP', issue_e)])
      end

      it do
        set = described_class.new([Scope.new('Ph1', issue_b)])
        set = set.add('Ph1', issue_c, order)
        expect(set).to eq described_class.new([Scope.new('Ph1', issue_c)])
      end

      it do
        set = described_class.new([Scope.new('Ph1', issue_b)])
        set = set.add('Ph2', issue_b, order)
        expect(set).to eq described_class.new([Scope.new('Ph2', issue_b)])
      end
    end

    describe 'Make releases' do
      it do
        set = described_class.new
        releases = set.make_releases(order)
        expect(releases).to be_empty
      end

      it do
        set = described_class.new([Scope.new('Ph1', issue_b), Scope.new('Ph2', issue_d)])
        releases = set.make_releases(order)
        expect(releases).to eq [
          Release.new('Ph1', [issue_a, issue_b]),
          Release.new('Ph2', [issue_c, issue_d]),
        ]
      end
    end
  end
end
