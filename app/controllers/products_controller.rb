# typed: ignore
class ProductsController < ApplicationController
  include TeamHelper

  before_action :require_user

  helper_method :all_team_roles

  def index
    @products = ProductListQuery.call(current_user.person_id.to_s)
  end

  def new
    @form = CreateProductForm.new
  end

  def create
    @form = CreateProductForm.new(permitted_params)
    if @form.valid?
      CreateProductWithTeamUsecase.perform(
        current_user.person_id,
        @form.domain_objects[:roles],
        @form.domain_objects[:name],
        @form.description,
      )
      redirect_to products_path, flash: flash_success('product.create')
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:name, :description, roles: [])
  end
end
