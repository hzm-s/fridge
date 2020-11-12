class ReleasesController < ApplicationController
  def create
    SpecifyReleaseUsecase.perform(
      Product::Id.from_string(params[:product_id]),
      params[:name],
      Issue::Id.from_string(params[:issue_id])
    )
    redirect_to product_backlog_path(product_id: params[:product_id]), flash: flash_success('release.create')
  end
end
