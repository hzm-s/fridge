class ProductBacklogItemEstimationsController < ApplicationController
  def update
    pbi_id = build_pbi_id(params[:id])
    point = build_point(params[:form][:point])
    EstimateProductBacklogItemSizeUsecase.new.perform(pbi_id, point)
  end

  private

  def build_pbi_id(id)
    Pbi::ItemId.from_string(id)
  end

  def build_point(point)
    point_as_i = point.present? ? point.to_i : nil
    Pbi::StoryPoint.from_integer(point_as_i)
  end
end
