# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:new_member) { sign_up }
  let!(:product) { create_product(members: [dev_member(sign_up.person_id)]) }
  let!(:team) { Dao::Team.find_by(dao_product_id: product.id.to_s) }

  describe '#new' do
    context 'when signed in' do
      before { sign_in(new_member) }

      it do
        get new_team_member_path(team_id: team.id)

        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end

    context 'when NOT signed in' do
      it do
        get new_team_member_path(team_id: team.id)
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
        post team_members_path(team_id: team.id), params: { role: 'scrum_master' }

        member = Dao::TeamMember.find_by(dao_person_id: new_member.person.id)
        expect(response.body).to include new_member.name
        expect(response.body).to include I18n.t('domain.team.role_short.scrum_master')
      end
    end

    xcontext 'when invalid params' do
      it do
        params = { role: 'product_owner' }
        post product_team_members_path(product_id: product.id), params: params

        expect(response.body).to include I18n.t('domain.errors.team.duplicated_product_owner')
      end
    end
  end
end
