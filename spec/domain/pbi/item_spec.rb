require 'rails_helper'

module Pbi
  describe Item do
    let(:content) { Pbi::Content.from_string('ABC') }

    describe '.create' do
      it 'idを持ち渡された内容を持つこと' do
        pbi = described_class.create(content)

        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.content).to eq content
        end
      end

      it '初期ステータスは準備中であること' do
        pbi = described_class.create(content)
        expect(pbi.status).to eq Pbi::Status::Preparation
      end

      it '初期サイズは不明であること' do
        pbi = described_class.create(content)
        expect(pbi.size).to eq Pbi::StoryPoint.unknown
      end
    end
  end
end
