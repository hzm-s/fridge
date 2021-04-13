# typed: false
require 'rails_helper'

describe SprintRepository::AR do
  let!(:product) { create_product }

  describe 'Store' do
    it do
      sprint = Sprint::Sprint.start(product.id, 11)

      expect { described_class.store(sprint) }
        .to change { Dao::Sprint.count }.by(1)

      aggregate_failures do
        dao = Dao::Sprint.last
        expect(dao.dao_product_id).to eq product.id.to_s
        expect(dao.number).to eq 11
      end
    end
  end

  describe 'Query next sprint number' do
    it do
      number = described_class.next_sprint_number(product.id)

      expect(number).to eq 1
    end

    it do
      previous = Sprint::Sprint.start(product.id, 50)
      described_class.store(previous)

      number = described_class.next_sprint_number(product.id)

      expect(number).to eq 51
    end
  end
end
