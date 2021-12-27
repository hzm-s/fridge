class ExportsController < ApplicationController
  def new
    @products = Dao::Product.all
  end

  def create
    @releases = Dao::Release.where(dao_product_id: params[:product_id])
    @pbis = Dao::Pbi.where(dao_product_id: params[:product_id])
  end
end
