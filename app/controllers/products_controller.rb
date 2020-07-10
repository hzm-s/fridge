class ProductsController < ApplicationController

  def index
    @products = Dao::Product.all
  end

  def new
    @form = ProductForm.new
  end
end
