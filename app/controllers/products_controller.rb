class ProductsController < ApplicationController
  
  def index
    @products = Dao::Product.all
  end
end
