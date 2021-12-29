# typed: false
require 'domain_helper'

module Sprint
  describe Sprint do
    let(:product_id) { Product::Id.create }

    describe 'Start' do
      it do
        sprint = described_class.start(product_id, 55)

        aggregate_failures do
          expect(sprint.id).to_not be_nil
          expect(sprint.product_id).to eq product_id
          expect(sprint.number).to eq 55
          expect(sprint).to_not be_finished
        end
      end
    end

    describe 'Finish' do
      it do
        sprint = described_class.start(product_id, 1)
        sprint.finish

        aggregate_failures do
          expect(sprint).to be_finished
          expect { sprint.finish }.to raise_error AlreadyFinished
        end
      end
    end

    let(:sprint) { described_class.start(product_id, 1) }
    let(:items) { pbi_list(pbi_a, pbi_b, pbi_c) }
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:dev_roles) { team_roles(:dev) }
    let(:po_roles) { team_roles(:po) }
    let(:sm_roles) { team_roles(:sm) }

    describe 'Update items' do
      it do
        sprint.update_items(po_roles, items)
        expect(sprint.items).to eq items
      end

      context 'when finished' do
        before { sprint.finish }

        it do
          expect { sprint.update_items(po_roles, items) }.to raise_error(AlreadyFinished)
        end
      end

      it 'PO can update items' do
        expect { sprint.update_items(po_roles, items) }.to_not raise_error
      end

      it 'Dev can NOT update items' do
        expect { sprint.update_items(dev_roles, items) }.to raise_error PermissonDenied
      end

      it 'SM can update items' do
        expect { sprint.update_items(sm_roles, items) }.to_not raise_error
      end
    end
  end
end
