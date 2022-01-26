# typed: ignore
class EstimationsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def update
    @form = EstimationForm.new(estimation_params)

    if @form.valid?
      pbi_id = Pbi::Id.from_string(params[:pbi_id])
      EstimatePbiUsecase.perform(
        pbi_id,
        current_team_member_roles,
        @form.domain_objects[:point],
      )
      @pbi = PbiQuery.call(pbi_id.to_s)
    else
      redirect_to product_backlog_path(product_id: current_product_id), flash: { error: @form.errors[:point].join(' ') }
    end
  end

  private

  def estimation_params
    params.require(:form).permit(:point)
  end

  def current_product_id
    @__currect_product_id ||= resolve_product_id_by_pbi_id(params[:pbi_id])
  end
end
