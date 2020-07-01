require 'rails_helper'

module Pbi
  describe Item do
    let(:content) { Pbi::Content.from_string('ABC') }

    describe 'create' do
      it do
        pbi = described_class.create(content)

        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.content).to eq content
        end
      end

      it do
        pbi = described_class.create(content)
        expect(pbi.status).to eq Pbi::Status::Preparation
      end
    end
  end
end
