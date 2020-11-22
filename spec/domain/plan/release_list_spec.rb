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
  end
end
