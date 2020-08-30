# typed: false
class PbiEstimationsController < ApplicationController
  def update
    feature_id = Pbi::Id.from_string(params[:id])
    point = build_point(params[:form][:point])
    EstimatePbiUsecase.perform(feature_id, point)

    @feature = PbiQuery.call(feature_id)
  end

  private

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Pbi::StoryPoint.new(point_as_i)
  end
end
