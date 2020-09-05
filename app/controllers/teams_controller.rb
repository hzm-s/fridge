# typed: false
class TeamsController < ApplicationController
  include ProductHelper

  def new
    @form = TeamForm.new(product_id: current_product_id, name: current_product.name)
  end

  def create
    @form = TeamForm.new(permitted_params)

    if @form.valid?
      CreateProductTeamUsecase.perform(
        @form.domain_objects[:product_id],
        @form.name
      )
      redirect_to products_path
    else
      render :new
    end
  end

  private

  def current_product_id
    params[:product_id] || params[:form][:product_id]
  end

  def permitted_params
    params.require(:form).permit(:product_id, :name)
  end
end
