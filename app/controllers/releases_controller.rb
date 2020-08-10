# typed: false
class ReleasesController < ApplicationController
  include ProductHelper

  def new
    @form = ReleaseForm.new
  end

  def create
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      product_id = Product::Id.from_string(params[:product_id])
      AddReleaseUsecase.perform(product_id, @form.title)
      redirect_to product_product_backlog_items_path(product_id: params[:product_id])
    else
      render :new
    end
  end

  private

  def release_params
    params.require(:form).permit(:title)
  end

  def current_product_id
    params[:product_id]
  end
end
