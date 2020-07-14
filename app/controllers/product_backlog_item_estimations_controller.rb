class ProductBacklogItemEstimationsController < ApplicationController
  def update
    pbi_id = build_pbi_id(params[:id])
    point = build_point(params[:form][:point])
    EstimateProductBacklogItemSizeUsecase.perform(pbi_id, point)

    @item = ProductBacklogItemQuery.call(pbi_id)
  end

  private

  def build_pbi_id(id)
    Pbi::Id.from_string(id)
  end

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Pbi::StoryPoint.from_integer(point_as_i)
  end
end
