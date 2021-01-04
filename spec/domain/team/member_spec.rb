# typed: false
require 'domain_helper'

module Team
  RSpec.describe Member do
    let(:person_a) { register_person }
    let(:person_b) { register_person }

    describe 'equality' do
      it do
        member_a = described_class.new(person_a.id, [Role::Developer])
        member_b = described_class.new(person_b.id, [Role::Developer])
        expect(member_a).to_not eq member_b
      end

      it do
        member_a1 = described_class.new(person_a.id, [Role::Developer])
        member_a2 = described_class.new(person_a.id, [Role::Developer])
        expect(member_a1).to eq member_a2
      end

      it do
        member_a1 = described_class.new(person_a.id, [Role::Developer, Role::ScrumMaster])
        member_a2 = described_class.new(person_a.id, [Role::ScrumMaster, Role::Developer])
        expect(member_a1).to eq member_a2
      end
    end
  end
end
