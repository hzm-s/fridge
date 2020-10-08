class ReleasePlansController < ApplicationController
  def show
    @releases = Dao::Release.where(dao_product_id: params[:product_id])
  end
end
