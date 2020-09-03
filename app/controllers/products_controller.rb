# typed: false
class ProductsController < ApplicationController

  def index
    @products = ProductListQuery.call(current_user.person_id.to_s)
  end

  def new
    @form = ProductForm.new
  end

  def create
    @form = ProductForm.new(permitted_params)
    if @form.valid?
      CreateProductUsecase.perform(
        current_user.person_id,
        @form.name,
        @form.description,
      )
      redirect_to products_path, flash: flash_success('product.create')
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:name, :description)
  end
end
