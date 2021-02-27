# typed: false
require 'rails_helper'

RSpec.describe AppendReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(roles, product.id, 'MVP')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.scheduled).to eq Plan::ReleaseList.new([
      Plan::Release.new('MVP', Plan::IssueList.new)
    ])
  end

  it do
    described_class.perform(roles, product.id, 'MVP')
    expect { described_class.perform(roles, product.id, 'MVP') }
      .to raise_error Plan::DuplicatedReleaseName
  end
end
