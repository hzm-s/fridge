# typed: false
require 'domain_helper'

module Sprint
  RSpec.describe Sprint do
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
    let(:issues) { issue_list(issue_a, issue_b, issue_c) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:dev_roles) { team_roles(:dev) }
    let(:po_roles) { team_roles(:po) }
    let(:sm_roles) { team_roles(:sm) }

    describe 'Update issue list' do
      it do
        sprint.update_issues(po_roles, issues)
        expect(sprint.issues).to eq issues
      end

      context 'when finished' do
        before { sprint.finish }

        it do
          expect { sprint.update_issues(po_roles, issues) }.to raise_error(AlreadyFinished)
        end
      end

      it 'PO can update issues' do
        expect { sprint.update_issues(po_roles, issues) }.to_not raise_error
      end

      it 'Dev can NOT update issues' do
        expect { sprint.update_issues(dev_roles, issues) }.to raise_error PermissonDenied
      end

      it 'SM can update issues' do
        expect { sprint.update_issues(sm_roles, issues) }.to_not raise_error
      end
    end
  end
end
