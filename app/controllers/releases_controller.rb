# typed: ignore
class ReleasesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  helper_method :current_product_id

  def new
    @form = ReleaseForm.new
  end

  def create
    @form = ReleaseForm.new(permitted_params)
    if @form.valid?
      AppendReleaseUsecase.perform(
        current_team_member_roles,
        Product::Id.from_string(current_product_id),
        @form.domain_objects[:title]
      )
      redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def edit
    @form = ReleaseForm.new(title: current_release.title)
  end

  def update
    @form = ReleaseForm.new(title: params[:form][:title])
    if @form.valid?
      ModifyReleaseTitleUsecase.perform(
        Product::Id.from_string(current_product_id),
        current_team_member_roles,
        release_number,
        @form.domain_objects[:title]
      )
      redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.update')
    else
      render :edit
    end
  end

  def destroy
    RemoveReleaseUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      current_release.number
    )
  rescue Plan::ReleaseIsNotEmpty
    redirect_to product_backlog_path(product_id: current_product_id), flash: flash_error('release.not_empty')
  else
    redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.destroy')
  end

  protected

  def current_product_id
    params[:product_id]
  end

  private

  def current_release
    ProductBacklogQuery.call(current_product_id).releases
      .then { |rs| rs.find { |r| r.number == release_number } }
  end

  def release_number
    params[:number].to_i
  end

  def permitted_params
    params.require(:form).permit(:title)
  end
end
