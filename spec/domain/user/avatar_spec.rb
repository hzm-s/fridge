# typed: false
require 'rails_helper'

module User
  RSpec.describe Avatar do
    describe '.create' do
      it do
        avatar = described_class.create('user@example.com')
        expect(avatar.initials).to eq 'US'
      end

      it do
        avatar = described_class.create('a@example.com')
        expect(avatar.initials).to eq 'AA'
      end

      it do
        expect { described_class.create('@example.com') }.to raise_error(ArgumentError)
      end
    end
  end
end
