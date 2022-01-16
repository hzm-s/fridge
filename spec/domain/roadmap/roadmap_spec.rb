# typed: false
require 'domain_helper'

module Roadmap
  describe Roadmap do
    let(:product_id) { Product::Id.create }
    let(:po_role) { team_roles(:po) }
    let(:dev_role) { team_roles(:dev) }
    let(:sm_role) { team_roles(:sm) }

    describe 'Create' do
      it do
        roadmap = described_class.create(product_id)

        aggregate_failures do
          expect(roadmap.product_id).to eq product_id
          expect(roadmap.releases.map(&:number)).to match_array [1]
        end
      end
    end

    describe 'Query recent release' do
      it do
        roadmap = described_class.create(product_id)
        roadmap.append_release(po_role)
        roadmap.append_release(po_role)
        roadmap.remove_release(po_role, 1)

        expect(roadmap.recent_release.number).to eq 2
      end
    end

    let(:roadmap) { described_class.create(product_id) }
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }

    describe 'Append release' do
      it do
        roadmap.append_release(po_role)
        roadmap.append_release(po_role, name('R3'))
        roadmap.append_release(po_role)
        roadmap.append_release(po_role)
        roadmap.remove_release(po_role, 4)
        roadmap.append_release(po_role)

        aggregate_failures do
          expect(roadmap.releases.map(&:number)).to match_array [1, 2, 3, 5, 6]
          expect(roadmap.release_of(3).title.to_s).to eq 'R3'
        end
      end

      it 'Dev can NOT append release' do
        expect { roadmap.append_release(dev_role) }.to raise_error PermissionDenied
      end

      it 'SM can append relaese' do
        expect { roadmap.append_release(sm_role) }.to_not raise_error
      end
    end

    describe 'Update release' do
      it do
        roadmap.append_release(po_role)

        updated =
          roadmap.release_of(1)
            .plan_item(pbi_a)
            .plan_item(pbi_b)
            .plan_item(pbi_c)
            .modify_title(name('Updated'))

        roadmap.update_release(po_role, updated)

        aggregate_failures do
          expect(roadmap.release_of(1).items).to eq pbi_list(pbi_a, pbi_b, pbi_c)
          expect(roadmap.release_of(1).title.to_s).to eq 'Updated'
          expect(roadmap.release_of(2).items).to eq pbi_list
        end
      end

      it 'Dev can NOT update release' do
        expect { roadmap.update_release(dev_role, roadmap.recent_release) }
          .to raise_error PermissionDenied
      end

      it 'SM can update relaese' do
        expect { roadmap.update_release(sm_role, roadmap.recent_release) }
          .to_not raise_error
      end
    end

    describe 'Remove release' do
      before do
        roadmap.append_release(po_role)
        roadmap.append_release(po_role)
      end

      it do
        roadmap.remove_release(po_role, 2)

        expect(roadmap.releases.map(&:number)).to match_array [1, 3]
      end

      it do
        roadmap.release_of(2)
          .plan_item(pbi_a)
          .then { |r| roadmap.update_release(po_role, r) }

        expect { roadmap.remove_release(po_role, 2) }.to raise_error ReleaseIsNotEmpty
      end

      it do
        roadmap.remove_release(po_role, 3)
        roadmap.remove_release(po_role, 2)

        expect { roadmap.remove_release(po_role, 1) }.to raise_error NeedAtLeastOneRelease
      end

      it 'Dev can NOT update release' do
        expect { roadmap.remove_release(dev_role, 2) }.to raise_error PermissionDenied
      end

      it 'SM can update relaese' do
        expect { roadmap.remove_release(sm_role, 2) }.to_not raise_error
      end
    end

    describe 'Query release by pbi' do
      it do
        roadmap.append_release(po_role)

        roadmap.release_of(1)
          .plan_item(pbi_a)
          .then { |r| roadmap.update_release(po_role, r) }

        roadmap.release_of(2)
          .plan_item(pbi_b)
          .plan_item(pbi_c)
          .then { |r| roadmap.update_release(po_role, r) }

        aggregate_failures do
          expect(roadmap.release_by_item(pbi_a).number).to eq 1
          expect(roadmap.release_by_item(pbi_b).number).to eq 2
          expect(roadmap.release_by_item(pbi_c).number).to eq 2
        end
      end
    end

    describe 'Query to remove release' do
      it do
        roadmap.append_release(po_role)

        expect(roadmap).to be_can_remove_release
      end

      it do
        expect(roadmap).to_not be_can_remove_release
      end
    end
  end
end
