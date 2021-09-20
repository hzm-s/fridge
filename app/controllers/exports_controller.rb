class ExportsController < ApplicationController
  def new
    @products = Dao::Product.all
  end

  def create
    @issues = Dao::Issue.where(dao_product_id: params[:product_id])
  end
end
