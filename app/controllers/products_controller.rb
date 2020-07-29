# typed: false
class ProductsController < ApplicationController

  def index
    @products = ProductQuery.call(current_user.id)
  end

  def new
    @form = ProductForm.new
  end

  def create
    @form = ProductForm.new(permitted_params)
    if @form.valid?
      CreateProductUsecase.perform(
        current_user.id_as_domain,
        @form.domain_objects[:member_role],
        @form.name,
        @form.description
      )
      redirect_to products_path, flash: flash_success('product.create')
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:name, :description, :member_role)
  end
end
