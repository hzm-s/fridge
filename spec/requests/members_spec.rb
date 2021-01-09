# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:new_member) { sign_up }
  let!(:product) { create_product(members: [dev_member(sign_up.person_id)]) }
  let!(:team) { resolve_team(product.id) }

  describe '#new' do
    context 'when signed in' do
      before { sign_in(new_member) }

      it do
        get new_team_member_path(team_id: team.id.to_s)

        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end

    context 'when NOT signed in' do
      it do
        get new_team_member_path(team_id: team.id.to_s)
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
        post team_members_path(team_id: team.id.to_s), params: { form: { roles: ['', 'scrum_master', 'developer'] } }
        follow_redirect!

        expect(response.body).to include product.name

        get team_path(team.id.to_s)
        expect(response.body).to include new_member.name
        expect(response.body).to include I18n.t('domain.team.role_short.scrum_master')
        expect(response.body).to include I18n.t('domain.team.role_short.developer')
      end
    end

    context 'when invalid params' do
      it do
        post team_members_path(team_id: team.id.to_s), params: { form: { roles: ['', '', ''] } }

        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end
end
