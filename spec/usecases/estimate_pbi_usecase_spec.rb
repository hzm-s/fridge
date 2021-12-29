# typed: false
require 'rails_helper'

describe EstimatePbiUsecase do
  let!(:product) { create_product }
  let(:roles) { team_roles(:dev) }
  let(:pbi) { add_pbi(product.id, 'ABC') }

  it do
    size = Pbi::StoryPoint.new(8)
    described_class.perform(pbi.id, roles, size)

    stored = PbiRepository::AR.find_by_id(pbi.id)
    expect(stored.size).to eq size
  end
end
