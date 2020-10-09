# typed: false
class ReleasePlansController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def show
    @releases = Dao::Release.where(dao_product_id: params[:product_id])
  end

  private

  def current_product_id
    params[:product_id]
  end
end
