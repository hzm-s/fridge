# typed: false
require 'rails_helper'

RSpec.describe AppendReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(roles, product.id, 'MVP')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.release_of(2).description).to eq 'MVP'
      expect(plan.release_of(2).issues).to eq issue_list
    end
  end
end
