# typed: false
require 'domain_helper'

module Plan
  describe Release do
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }

    describe 'Create' do
      it do
        r = described_class.new(1, name('MVP'))

        aggregate_failures do
          expect(r.number).to eq 1
          expect(r.title.to_s).to eq 'MVP'
          expect(r.items).to eq pbi_list
        end
      end

      it 'has default title' do
        r = described_class.new(1)
        expect(r.title.to_s).to eq 'Release#1'
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.new(1, name('Initial'))
        modified = release.modify_title(name('Modified'))
        expect(modified.title.to_s).to eq 'Modified'
      end
    end

    describe 'Plan item' do
      let(:release) { described_class.new(1) }

      it do
        updated = release.plan_item(pbi_c)

        expect(updated.items).to eq pbi_list(pbi_c)
      end

      it do
        updated = release.plan_item(pbi_a)

        expect { updated.plan_item(pbi_a) }.to raise_error DuplicatedItem
      end
    end

    describe 'Drop item' do
      it do
        initial = described_class.new(1, nil, pbi_list(pbi_a, pbi_b, pbi_c))

        updated = initial.drop_item(pbi_b)

        expect(updated.items).to eq pbi_list(pbi_a, pbi_c)
      end
    end

    describe 'Change item priority' do
      it do
        initial = described_class.new(1, nil, pbi_list(pbi_a, pbi_b, pbi_c))

        updated = initial.change_item_priority(pbi_c, pbi_a)

        expect(updated.items).to eq pbi_list(pbi_c, pbi_a, pbi_b)
      end
    end
  end
end
