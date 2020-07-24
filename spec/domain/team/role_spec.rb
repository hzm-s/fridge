# typed: false
require 'rails_helper'

module Team
  RSpec.describe Role do
    context 'when Product Owner' do
      it do
        role = Role::ProductOwner
        expect(role.unavailable_actions_for_pbi).to match_array [:estimate_size]
        expect(role.to_s).to eq 'product_owner'
      end
    end

    context 'when Developer' do
      it do
        role = Role::Developer
        expect(role.unavailable_actions_for_pbi).to match_array [:sort]
      end
    end

    context 'when Scrum Master' do
      it do
        role = Role::ScrumMaster
        expect(role.unavailable_actions_for_pbi).to match_array [:estimate_size]
      end
    end
  end
end
