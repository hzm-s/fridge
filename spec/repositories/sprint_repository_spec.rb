# typed: false
require 'rails_helper'

describe SprintRepository::AR do
  let!(:product) { create_product }

  describe 'Add' do
    it do
      sprint = Sprint::Sprint.start(product.id, 11)

      expect { described_class.store(sprint) }
        .to change { Dao::Sprint.count }.by(1)

      aggregate_failures do
        dao = Dao::Sprint.last
        expect(dao.dao_product_id).to eq product.id.to_s
        expect(dao.number).to eq 11
        expect(dao.is_finished).to be false
        expect(dao.items).to be_empty
      end
    end
  end

  describe 'Update' do
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:po_roles) { team_roles(:po) }

    it do
      sprint = Sprint::Sprint.start(product.id, 11)
      described_class.store(sprint)

      sprint.update_items(po_roles, sprint.items.append(pbi_a))
      expect { described_class.store(sprint) }
        .to change { Dao::Sprint.count }.by(0)

      sprint.update_items(po_roles, sprint.items.append(pbi_b))
      sprint.update_items(po_roles, sprint.items.append(pbi_c))
      expect { described_class.store(sprint) }
        .to change { Dao::Sprint.count }.by(0)

      aggregate_failures do
        dao = Dao::Sprint.last
        expect(dao.dao_product_id).to eq product.id.to_s
        expect(dao.number).to eq 11
        expect(dao.is_finished).to be false
        expect(dao.items).to eq [pbi_a, pbi_b, pbi_c].map(&:to_s)
      end
    end
  end

  describe 'Query current sprint' do
    it do
      current = described_class.current(product.id)
      expect(current).to be_nil

      s1 = Sprint::Sprint.start(product.id, 1)
      s1.finish
      described_class.store(s1)

      s2 = Sprint::Sprint.start(product.id, 2)
      s2.finish
      described_class.store(s2)

      s3 = Sprint::Sprint.start(product.id, 3)
      described_class.store(s3)

      current = described_class.current(product.id)
      expect(current.id).to eq s3.id

      s3.finish
      described_class.store(s3)
      current = described_class.current(product.id)
      expect(current).to be_nil
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
