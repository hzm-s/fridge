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
      redirect_to product_pbis_path(product_id: params[:product_id]), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def edit
    release = fetch_release
    @form = ReleaseForm.new(title: release.title)
  end

  def update
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      product_id = Product::Id.from_string(current_product_id)
      ModifyReleaseTitleUsecase.perform(product_id, params[:no].to_i, @form.title)
      redirect_to product_pbis_path(product_id: product_id.to_s), flash: flash_success('release.update')
    else
      render :edit
    end
  end

  def destroy
    product_id = Product::Id.from_string(current_product_id)
    RemoveReleaseUsecase.perform(product_id, params[:no].to_i)
    flash = flash_success('release.destroy')
  rescue Release::CanNotRemoveRelease => e
    flash = { notice: t_domain_error(e) }
  ensure
    redirect_to product_pbis_path(product_id: product_id.to_s), flash: flash
  end

  private

  def release_params
    params.require(:form).permit(:title)
  end

  def fetch_release
    product_id = Product::Id.from_string(params[:product_id])
    no = Release::Id.from_string(params[:no]).to_i

    PlanRepository::AR.find_by_product_id(product_id).release(no)
  end

  def current_product_id
    params[:product_id]
  end
end
