# typed: false
require 'rails_helper'

module Team
  RSpec.describe Role do
    context 'when Product Owner' do
      it do
        role = Role::ProductOwner
        expect(role.available_actions_for_pbi).to match_array [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
        expect(role.to_s).to eq 'product_owner'
      end
    end

    context 'when Developer' do
      it do
        role = Role::Developer
        expect(role.available_actions_for_pbi).to match_array [:add, :update, :add_acceptance_criteria, :remove_acceptance_criteria]
      end
    end

    context 'when Scrum Master' do
      it do
        role = Role::ScrumMaster
        expect(role.available_actions_for_pbi).to match_array [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
      end
    end
  end
end
