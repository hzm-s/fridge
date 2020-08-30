# typed: false
class PbiEstimationsController < ApplicationController
  def update
    pbi_id = Pbi::Id.from_string(params[:id])
    point = build_point(params[:form][:point])
    EstimatePbiUsecase.perform(pbi_id, point)

    @pbi = PbiQuery.call(pbi_id)
  end

  private

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Pbi::StoryPoint.new(point_as_i)
  end
end
