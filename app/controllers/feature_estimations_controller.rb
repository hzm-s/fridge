# typed: false
class FeatureEstimationsController < ApplicationController
  def update
    feature_id = Feature::Id.from_string(params[:id])
    point = build_point(params[:form][:point])
    EstimateFeatureUsecase.perform(feature_id, point)

    @feature = FeatureQuery.call(feature_id)
  end

  private

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Feature::StoryPoint.new(point_as_i)
  end
end
