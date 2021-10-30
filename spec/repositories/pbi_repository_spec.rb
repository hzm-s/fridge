# typed: false
require 'rails_helper'

RSpec.describe PbiRepository::AR do
  let!(:product) { create_product }

  describe 'Add' do
    it do
      pbi = Pbi::Pbi.draft(product.id, Pbi::Types.from_string('feature'), l_sentence('feat'))

      expect { described_class.store(pbi) }
        .to change { Dao::Pbi.count }.by(1)
        .and change { Dao::AcceptanceCriterion.count }.by(0)

      aggregate_failures do
        dao = Dao::Pbi.last
        expect(dao.id).to eq pbi.id.to_s
        expect(dao.dao_product_id).to eq pbi.product_id.to_s
        expect(dao.pbi_type).to eq pbi.type.to_s
        expect(dao.status).to eq pbi.status.to_s
        expect(dao.description).to eq pbi.description.to_s
        expect(dao.size).to be_nil
        expect(dao.criteria).to be_empty
      end
    end
  end
end
