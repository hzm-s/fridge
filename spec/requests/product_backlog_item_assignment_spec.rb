# typed: false
require 'rails_helper'

RSpec.describe 'product_backlog_item_assignment' do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(ac1), size: 2) }

  describe '#create' do
    it do
      expect {
        post product_backlog_item_assignments_path(id: pbi.id.to_s, format: :js)
      }
        .to change { Dao::ProductBacklogItem.find(pbi.id.to_s).status }
        .from(Pbi::Statuses::Ready.to_s)
        .to(Pbi::Statuses::Wip.to_s)
    end

    it do
      post product_backlog_item_assignments_path(id: pbi.id.to_s, format: :js)
      expect(response.body).to include 'wip'
    end
  end

  describe '#destroy' do
    before do
      assign_pbi(pbi.id)
    end

    it do
      expect {
        delete product_backlog_item_assignment_path(pbi.id.to_s, format: :js)
      }
        .to change { Dao::ProductBacklogItem.find(pbi.id.to_s).status }
        .from(Pbi::Statuses::Wip.to_s)
        .to(Pbi::Statuses::Ready.to_s)
    end

    it do
      delete product_backlog_item_assignment_path(pbi.id.to_s, format: :js)
      expect(response.body).to include 'ready'
    end
  end
end
