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
    product_id = Product::Id.from_string(current_product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)
    release = plan.release(params[:no].to_i)
    @form = ReleaseForm.new(title: release.title)
  end

  def update
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      product_id = Product::Id.from_string(current_product_id)
      no = params[:no].to_i
      ChangeReleaseTitleUsecase.perform(product_id, no, @form.title)
      redirect_to product_product_backlog_items_path(product_id: current_product_id), flash: flash_success('release.update')
    else
      render :edit
    end
  end

  def destroy
    product_id = Product::Id.from_string(current_product_id)
    no = params[:no].to_i
    RemoveReleaseUsecase.perform(product_id, no)

    flash = flash_success('release.destroy')
  rescue Plan::CanNotRemoveRelease, Plan::AtLeastOneReleaseIsRequired => e
    flash = { notice: t_domain_error(e) }
  ensure
    redirect_to product_product_backlog_items_path(product_id: current_product_id), flash: flash
  end

  private

  def release_params
    params.require(:form).permit(:title)
  end

  def current_product_id
    params[:product_id]
  end
end
