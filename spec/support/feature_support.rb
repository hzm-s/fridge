# typed: true
require_relative '../domain_support/feature_domain_support'

module FeatureSupport
  include FeatureDomainSupport

  def add_feature(product_id, description = 'fridge helps scrum', acceptance_criteria: [], size: nil, assigned: false)
    feature = perform_add_feature(product_id, description)

    return feature unless acceptance_criteria
    add_acceptance_criteria(feature, acceptance_criteria)

    return feature unless size
    estimate_feature(feature.id, size)

    return feature unless assigned
    assign_feature(feature.id)

    FeatureRepository::AR.find_by_id(feature.id)
  end

  def add_acceptance_criteria(feature, contents_or_criteria)
    criteria = contents_or_criteria.map do |cc|
      cc.is_a?(String)? acceptance_criterion(cc) : cc
    end
    criteria.each do |ac|
      AddAcceptanceCriterionUsecase.perform(feature.id, ac)
    end
  end

  def estimate_feature(feature_id, size)
    EstimateFeatureUsecase.perform(feature_id, Feature::StoryPoint.new(size))
  end

  def assign_feature(feature_id)
    AssignProductBacklogItemUsecase.perform(feature_id)
  end

  def remove_feature(feature_id)
    RemoveProductBacklogItemUsecase.perform(feature_id)
  end

  def add_release(product_id, title = 'Release2')
    AddReleaseUsecase.perform(product_id, title)
      .yield_self { |id| ReleaseRepository::AR.find_by_id(id) }
  end

  private

  def perform_add_feature(product_id, desc)
    Feature::Description.new(desc)
      .yield_self { |d| AddFeatureUsecase.perform(product_id, d) }
      .yield_self { |id| FeatureRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include FeatureSupport
end
