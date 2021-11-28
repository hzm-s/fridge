# typed: false
require 'domain_helper'

module Sbi
  RSpec.describe Sbi do
    let(:pbi_id) { Pbi::Id.create }

    context 'Plan' do
      it do
        sbi = described_class.plan(pbi_id)

        aggregate_failures do
          expect(sbi.id).to_not be_nil
          expect(sbi.pbi_id)
          expect(sbi.tasks).to be_empty
        end
      end
    end
  end
end
