# typed: false
require 'rails_helper'

RSpec.describe 'pbi_developments' do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(ac1), size: 2) }

  describe '#create' do
    it do
      expect {
        post pbi_developments_path(id: pbi.id.to_s, format: :js)
      }
        .to change { Dao::Pbi.find(pbi.id.to_s).status }
        .from(Pbi::Statuses::Ready.to_s)
        .to(Pbi::Statuses::Wip.to_s)
    end

    it do
      post pbi_developments_path(id: pbi.id.to_s, format: :js)
      expect(response.body).to include 'wip'
    end
  end

  describe '#destroy' do
    before do
      start_pbi_development(pbi.id)
    end

    it do
      expect {
        delete pbi_development_path(pbi.id.to_s, format: :js)
      }
        .to change { Dao::Pbi.find(pbi.id.to_s).status }
        .from(Pbi::Statuses::Wip.to_s)
        .to(Pbi::Statuses::Ready.to_s)
    end

    it do
      delete pbi_development_path(pbi.id.to_s, format: :js)
      expect(response.body).to include 'ready'
    end
  end
end
