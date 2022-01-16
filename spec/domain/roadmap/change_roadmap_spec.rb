# typed: false
require 'domain_helper'

module Roadmap
  describe ChangeRoadmap do
    let(:product_id) { Product::Id.create }
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:pbi_d) { Pbi::Id.create }
    let(:pbi_e) { Pbi::Id.create }
    let(:roles) { team_roles(:po) }

    let(:roadmap) do
      Roadmap.create(product_id).tap do |roadmap|
        roadmap.append_release(roles)
        roadmap.release_of(1)
          .plan_item(pbi_a)
          .plan_item(pbi_b)
          .then { |r| roadmap.update_release(roles, r) }

        roadmap.append_release(roles)
        roadmap.release_of(2)
          .plan_item(pbi_c)
          .plan_item(pbi_d)
          .plan_item(pbi_e)
          .then { |r| roadmap.update_release(roles, r) }

        roadmap.append_release(roles)
      end
    end

    let(:change) { described_class.new(roles) }

    describe 'Change item priority' do
      it do
        changed = change.change_item_priority(roadmap, pbi_e, pbi_c)

        aggregate_failures do
          expect(changed.release_of(1).items).to eq pbi_list(pbi_a, pbi_b)
          expect(changed.release_of(2).items).to eq pbi_list(pbi_e, pbi_c, pbi_d)
          expect(changed.release_of(3).items).to eq pbi_list
        end
      end
    end

    describe 'Reschedule item' do
      it do
        changed = change.reschedule(roadmap, pbi_c, 1, pbi_b)

        aggregate_failures do
          expect(changed.release_of(1).items).to eq pbi_list(pbi_a, pbi_c, pbi_b)
          expect(changed.release_of(2).items).to eq pbi_list(pbi_d, pbi_e)
          expect(changed.release_of(3).items).to eq pbi_list
        end
      end

      it do
        changed = change.reschedule(roadmap, pbi_d, 3, nil)

        aggregate_failures do
          expect(changed.release_of(1).items).to eq pbi_list(pbi_a, pbi_b)
          expect(changed.release_of(2).items).to eq pbi_list(pbi_c, pbi_e)
          expect(changed.release_of(3).items).to eq pbi_list(pbi_d)
        end
      end

      it do
        changed = change.reschedule(roadmap, pbi_c, 1, nil)

        aggregate_failures do
          expect(changed.release_of(1).items).to eq pbi_list(pbi_a, pbi_b, pbi_c)
          expect(changed.release_of(2).items).to eq pbi_list(pbi_d, pbi_e)
          expect(changed.release_of(3).items).to eq pbi_list
        end
      end
    end
  end
end
