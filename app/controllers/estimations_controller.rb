# typed: ignore
class EstimationsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def update
    pbi_id = Pbi::Id.from_string(params[:pbi_id])
    EstimatePbiUsecase.perform(
      pbi_id,
      current_team_member_roles,
      build_point(params[:form][:point]),
    )
    @pbi = PbiQuery.call(pbi_id.to_s)
  end

  private

  def build_point(point)
    point_as_i = point == '?' ? nil : point.to_i
    Pbi::StoryPoint.new(point_as_i)
  end

  def current_product_id
    @__currect_product_id ||= resolve_product_id_by_pbi_id(params[:pbi_id])
  end
end
