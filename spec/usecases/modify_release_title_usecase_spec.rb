# typed: false
require 'rails_helper'

RSpec.describe ModifyReleaseTitleUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, 1, 'R1')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.release_of(1).title).to eq 'R1'
      expect(plan.release_of(1).issues).to eq issue_list
    end
  end
end
