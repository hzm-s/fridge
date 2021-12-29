# typed: false
require 'domain_helper'

module Person
  describe Person do
    describe '.create' do
      it do
        user = described_class.create('user', 'user@example.com')

        expect(user.name).to eq 'user'
        expect(user.email).to eq 'user@example.com'
      end
    end
  end
end
