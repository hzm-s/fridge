# typed: false
require 'rails_helper'

RSpec.describe FeatureRepository::AR do
  let!(:product) { create_product }

  describe '#create' do
    it do
      feature = Feature::Feature.create(product.id, Feature::Description.new('ABC'))
      expect { described_class.add(feature) }
        .to change { Dao::Feature.count }.by(1)
    end
  end

  xdescribe '#update' do
    it do
      feature = add_feature(product.id)
      feature.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2)))

      expect { described_class.update(feature) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(2)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2).to_a)
    end

    it do
      feature = add_feature(product.id, acceptance_criteria: %w(AC1 AC2 AC3 AC4))
      feature.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))

      expect { described_class.update(feature) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2 AC3).to_a)
    end

    it do
      feature = add_feature(product.id, acceptance_criteria: %w(ac1))
      feature.estimate_size(feature::StoryPoint.new(5))

      described_class.update(feature)
      updated = described_class.find_by_id(feature.id)

      expect(updated.status).to eq feature.status
    end
  end

  describe '#delete' do
    it do
      feature = add_feature(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

      expect { described_class.delete(feature.id) }
        .to change { Dao::Feature.count }.by(-1)
        .and change { Dao::AcceptanceCriterion.count }.by(-3)
    end
  end
end
