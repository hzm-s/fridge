# typed: false
class PbisController < ApplicationController
  include ProductHelper

  before_action :require_user

  helper_method :current_product_id

  def index
    @releases = ProductBacklogQuery.call(params[:product_id])
    @form = FeatureForm.new
  end

  def create
    @form = FeatureForm.new(permitted_params)

    if @form.valid?
      AddFeatureUsecase.perform(
        Product::Id.from_string(params[:product_id]),
        @form.domain_objects[:description]
      )
      redirect_to product_pbis_path(product_id: params[:product_id]), flash: flash_success('pbi.create')
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:description)
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    Dao::ProductBacklogItem.find(params[:id]).product_id
  end
end
