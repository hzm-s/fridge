# typed: false
require 'domain_helper'

module User
  RSpec.describe User do
    describe '.create' do
      it do
        user = described_class.create('user', 'user@example.com')
        expect(user.initials).to eq 'US'
      end

      it do
        user = described_class.create('user', 'a@example.com')
        expect(user.initials).to eq 'AA'
      end

      it do
        expect { described_class.create('user', '@example.com') }.to raise_error(ArgumentError)
      end
    end
  end
end
