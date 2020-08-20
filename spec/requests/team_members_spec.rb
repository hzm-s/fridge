# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:founder) { sign_up }
  let!(:new_member) { sign_up }
  let!(:product) { create_product(person_id: Person::Id.from_string(founder.person.id), role: Team::Role::ProductOwner) }

  describe '#index' do
    before { sign_in(founder) }

    it do
      get product_team_members_path(product_id: product.id.to_s)
      expect(response.body).to include founder.person.name
    end
  end

  describe '#new' do
    context 'when signed in' do
      before { sign_in(new_member) }

      it do
        get new_product_team_member_path(product_id: product.id)

        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end

    context 'when NOT signed in' do
      it do
        get new_product_team_member_path(product_id: product.id)
        sign_in(new_member)
        follow_redirect!

        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end
  end

  describe '#create' do
    before { sign_in(new_member) }

    context 'when valid params' do
      it do
        params = { role: 'developer' }
        post product_team_members_path(product_id: product.id), params: params

        member = Dao::TeamMember.find_by(dao_person_id: new_member.person.id)
        expect(member.role).to eq 'developer'
      end
    end

    context 'when invalid params' do
      it do
        params = { role: 'product_owner' }
        post product_team_members_path(product_id: product.id), params: params

        expect(response.body).to include I18n.t('domain.errors.team.duplicated_product_owner')
      end
    end
  end
end
