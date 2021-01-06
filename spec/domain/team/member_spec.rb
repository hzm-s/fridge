# typed: false
require 'domain_helper'

module Team
  RSpec.describe Member do
    let(:person_a) { register_person }
    let(:person_b) { register_person }

    describe 'same person query' do
      it do
        member_a = described_class.new(person_a.id, RoleSet.new([Role::ScrumMaster, Role::Developer]))
        member_b = described_class.new(person_a.id, RoleSet.new([Role::Developer]))
        expect(member_a.same_person?(member_a.person_id)).to be true
      end

      it do
        member_a = described_class.new(person_a.id, RoleSet.new([Role::ScrumMaster, Role::Developer]))
        member_b = described_class.new(person_b.id, RoleSet.new([Role::Developer]))
        expect(member_a.same_person?(member_b.person_id)).to be false
      end
    end

    describe 'equality' do
      it do
        member_a = described_class.new(person_a.id, RoleSet.new([Role::Developer]))
        member_b = described_class.new(person_b.id, RoleSet.new([Role::Developer]))
        expect(member_a).to_not eq member_b
      end

      it do
        member_a1 = described_class.new(person_a.id, RoleSet.new([Role::Developer]))
        member_a2 = described_class.new(person_a.id, RoleSet.new([Role::Developer]))
        expect(member_a1).to eq member_a2
      end

      it do
        member_a1 = described_class.new(person_a.id, RoleSet.new([Role::Developer, Role::ScrumMaster]))
        member_a2 = described_class.new(person_a.id, RoleSet.new([Role::ScrumMaster, Role::Developer]))
        expect(member_a1).to eq member_a2
      end
    end
  end
end
