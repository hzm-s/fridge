# typed: false
require 'rails_helper'

RSpec.describe RemovePbiUsecase do
  let!(:product) { create_product }
  let!(:stay) { add_pbi(product.id) }

  it 'DBとプロダクトバックログに存在しないこと' do
    target = add_pbi(product.id)
    described_class.perform(target.id)

    expect { PbiRepository::AR.find_by_id(target.id) }
      .to raise_error(ActiveRecord::RecordNotFound)

    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.release(1).items).to match_array [stay.id]
  end

  it '着手アイテムは削除できないこと' do
    wip = add_pbi(product.id, acceptance_criteria: %w(criterion), size: 8, wip: true)

    expect { described_class.perform(wip.id) }.to raise_error(Pbi::CanNotRemove)
  end

  xit do
    add_release(product.id, 'R2')
    item2 = add_pbi(product.id)

    add_release(product.id, 'R3')
    item3 = add_pbi(product.id)

    described_class.perform(item2.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.release(2).items).to be_empty
  end
end
