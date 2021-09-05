# typed: false
require 'rails_helper'

RSpec.describe 'feature_estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:feature) { plan_issue(product.id, type: :feature) }

  describe '#update' do
    before { sign_in(user_account) }

    it do
      put feature_estimation_path(feature.id, format: :js), params: { form: { point: '8' } }

      stored = IssueRepository::AR.find_by_id(feature.id)
      expect(stored.size.to_i).to eq 8
    end

    it do
      put feature_estimation_path(feature.id, format: :js), params: { form: { point: '?' } }

      stored = IssueRepository::AR.find_by_id(feature.id)
      expect(stored.size.to_i).to eq nil 
    end

    it do
      put feature_estimation_path(feature.id, format: :js), params: { form: { point: '2' } }
      expect(response.body).to_not include 'test-item-movable'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { put feature_estimation_path(1, format: :js) } }
end
