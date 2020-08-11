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

  def edit
    product_id = Product::Id.from_string(current_product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)
    release = plan.releases[params[:no].to_i - 1]
    @form = ReleaseForm.new(title: release.title)
  end

  def update
    @form = ReleaseForm.new(release_params)

    if @form.valid?
      product_id = Product::Id.from_string(current_product_id)
      no = params[:no].to_i
      ChangeReleaseTitleUsecase.perform(product_id, no, @form.title)
      redirect_to product_product_backlog_items_path(product_id: current_product_id)
    else
      render :edit
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
