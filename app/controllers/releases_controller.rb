# typed: false
class ReleasesController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def new
    @form = ReleaseForm.new
  end

  def create
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      product_id = Product::Id.from_string(params[:product_id])
      AddReleaseUsecase.perform(product_id, @form.title)
      redirect_to release_plan_path(params[:product_id]), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def edit
    @form = ReleaseForm.new(title: current_release.title)
  end

  def update
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      ModifyReleaseTitleUsecase.perform(current_release.id, @form.title)
      redirect_to product_backlog_path(product_id: current_product_id.to_s), flash: flash_success('release.update')
    else
      render :edit
    end
  end

  def destroy
    RemoveReleaseUsecase.perform(current_release.id)
    redirect_to product_backlog_path(product_id: current_product_id.to_s), flash: flash_success('release.destroy')
  end

  private

  def release_params
    params.require(:form).permit(:title)
  end

  def current_release
    @__current_release ||= ReleaseRepository::AR.find_by_id(release_id)
  end

  def release_id
    @__release_id ||= Release::Id.from_string(params[:id])
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    current_release.product_id.to_s
  end
end
