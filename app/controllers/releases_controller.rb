# typed: false
class ReleasesController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def new
    @form = ReleaseForm.new
  end

  def create
    AddReleaseUsecase.perform(
      Product::Id.from_string(params[:product_id]),
      params[:name],
    )
    redirect_to product_backlog_path(product_id: params[:product_id]), flash: flash_success('release.create')
  end

  def current_product_id
    params[:product_id]
  end
end
