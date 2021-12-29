# typed: false
require 'rails_helper'

describe PbiStruct do
  let!(:product) { create_product }

  it 'returns acceptance criteria' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3))
    s = build_struct { pbi }

    aggregate_failures do
      expect(s.criteria.map(&:pbi_id).uniq).to eq [pbi.id.to_s]
      expect(s.criteria[0].number).to eq 1
      expect(s.criteria[0].content).to eq 'AC1'
      expect(s.criteria[1].number).to eq 2
      expect(s.criteria[1].content).to eq 'AC2'
      expect(s.criteria[2].number).to eq 3
      expect(s.criteria[2].content).to eq 'AC3'
    end
  end

  it 'returns status' do
    pbi = add_pbi(product.id)
    s = build_struct { pbi }
    expect(s.status).to eq pbi.status
  end

  private

  def build_struct
    yield.then { |i| described_class.new(Dao::Pbi.find(i.id)) }
  end
end
