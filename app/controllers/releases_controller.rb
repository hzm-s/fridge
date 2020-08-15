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
      redirect_to product_product_backlog_items_path(product_id: params[:product_id]), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def edit
    release_id = Release::Id.from_string(params[:id])
    release = ReleaseRepository::AR.find_by_id(release_id)
    @form = ReleaseForm.new(title: release.title)
  end

  def update
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      release = current_release
      ChangeReleaseTitleUsecase.perform(release.id, @form.title)
      redirect_to product_product_backlog_items_path(product_id: release.product_id.to_s), flash: flash_success('release.update')
    else
      render :edit
    end
  end

  def destroy
    release = current_release
    RemoveReleaseUsecase.perform(release.id)
    flash = flash_success('release.destroy')
  rescue Release::CanNotRemoveRelease, Release::AtLeastOneReleaseIsRequired => e
    flash = { notice: t_domain_error(e) }
  ensure
    redirect_to product_product_backlog_items_path(product_id: release.product_id.to_s), flash: flash
  end

  private

  def release_params
    params.require(:form).permit(:title)
  end

  def current_release
    @__current_release = ReleaseRepository::AR.find_by_id(Release::Id.from_string(params[:id]))
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    current_release.product_id.to_s
  end
end
