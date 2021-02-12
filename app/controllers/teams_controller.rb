# typed: false
class TeamsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  def show
    @team = TeamQuery.call(params[:id])
  end

  private

  def current_product_id
    if params[:id]
      TeamQuery.call(params[:id]).product.id
    else
      params[:product_id] || params[:form][:product_id]
    end
  end

  def permitted_params
    params.require(:form).permit(:product_id, :name)
  end
end
