# typed: false
require 'domain_helper'

module Plan
  RSpec.describe ReleaseList do
    describe 'Add' do
      it do
        list = described_class.new
        list = list.add(Release.new('MVP'))
        expect(list).to eq described_class.new([
          Release.new('MVP')
        ])
      end
    end

    describe 'Remove' do
      it do
        list = described_class.new([Release.new('R1'), Release.new('R2'), Release.new('R3')])
        list = list.remove('R2')
        expect(list).to eq described_class.new([
          Release.new('R1'),
          Release.new('R3')
        ])
      end

      it do
        list = described_class.new([Release.new('R1', issue_list(Issue::Id.create))])
        expect { list.remove('R1') }.to raise_error ReleaseIsNotEmpty
      end
    end
  end
end
