class ProductsController < ApplicationController

  def index
    @products = Dao::Product.all
  end

  def new
    @form = ProductForm.new
  end

  def create
    @form = ProductForm.new(permitted_params)
    if @form.valid?
      CreateProductUsecase.perform(@form.name, @form.description)
      redirect_to products_path
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:name, :description)
  end
end
