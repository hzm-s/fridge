# typed: false
require 'rails_helper'

RSpec.describe SbiRepository::AR do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  describe 'Add' do
    it do
      sbi = Sbi::Sbi.plan(pbi.id)

      expect { described_class.store(sbi) }
        .to change { Dao::Sbi.count }.from(0).to(1)

      aggregate_failures do
        dao = Dao::Sbi.last
        expect(dao.id).to eq sbi.id.to_s
        expect(dao.dao_pbi_id).to eq sbi.pbi_id.to_s
      end
    end
  end
end