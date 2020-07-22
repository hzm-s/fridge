# typed: false
require 'rails_helper'

module Team
  RSpec.describe Role do
    context 'when Product Owner' do
      it do
        role = described_class.product_owner
        expect(role.available_actions_for_pbi).to match_array [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
      end
    end

    context 'when Developer' do
      it do
        role = described_class.developer
        expect(role.available_actions_for_pbi).to match_array [:add, :update, :add_acceptance_criteria, :remove_acceptance_criteria]
      end
    end

    context 'when Scrum Master' do
      it do
        role = described_class.scrum_master
        expect(role.available_actions_for_pbi).to match_array [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
      end
    end
  end
end
