# typed: false
class ReleasesController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def new
    @form = ReleaseForm.new
  end

  def create
    @form = ReleaseForm.new(permitted_params)
    if @form.valid?
      AddReleaseUsecase.perform(
        Product::Id.from_string(params[:product_id]),
        @form.name
      )
      redirect_to product_backlog_path(product_id: params[:product_id]), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def current_product_id
    params[:product_id]
  end

  private

  def permitted_params
    params.require(:form).permit(:name)
  end
end
