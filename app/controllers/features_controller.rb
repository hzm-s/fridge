# typed: false
class FeaturesController < ApplicationController
  include ProductHelper

  before_action :require_user

  helper_method :current_product_id

  def create
    @form = FeatureForm.new(permitted_params)

    if @form.valid?
      AddFeatureUsecase.perform(
        Product::Id.from_string(params[:product_id]),
        @form.domain_objects[:description]
      )
      redirect_to product_pbis_path(product_id: params[:product_id]), flash: flash_success('feature.create')
    else
      render :new
    end
  end

  def edit
    @feature = FeatureQuery.call(params[:id])
    @form = FeatureForm.new(description: @feature.description)
  end

  def update
    @feature_id = params[:id]
    @form = FeatureForm.new(permitted_params)

    if @form.valid?
      ModifyFeatureUsecase.perform(
        Feature::Id.from_string(@feature_id),
        @form.domain_objects[:description]
      )
      redirect_to edit_feature_path(@feature_id), flash: flash_success('feature.update')
    else
      render :edit
    end
  end

  def destroy
    feature = FeatureRepository::AR.find_by_id(Feature::Id.from_string(params[:id]))
    RemoveFeatureUsecase.perform(feature.id)
    redirect_to product_pbis_path(product_id: feature.product_id), flash: flash_success('feature.destroy')
  end

  private

  def permitted_params
    params.require(:form).permit(:description)
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    Dao::Feature.find(params[:id]).product_id
  end
end
