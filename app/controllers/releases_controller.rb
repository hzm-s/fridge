# typed: false
class ReleasesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

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
          @form.description
        )
        redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.create')
    else
      render :new
    end
  end

  def edit
    @form = ReleaseForm.new(description: current_release.description, index: release_index)
  end

  def update
    @form = ReleaseForm.new(description: params[:form][:description], index: release_index)
    if @form.valid?
      begin
        ChangeReleaseNameUsecase.perform(
          Product::Id.from_string(current_product_id),
          current_team_member_roles,
          @form.description,
          current_release.description
        )
      rescue Plan::DuplicatedReleaseName => e
        @form.errors.add(:name, t_domain_error(e.class))
        render :edit
      else
        redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.update')
      end
    else
      render :edit
    end
  end

  def destroy
    RemoveReleaseUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      current_release.name
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
    ProductBacklogQuery.call(current_product_id).scheduled[release_index]
  end

  def release_index
    params[:id].to_i
  end

  def permitted_params
    params.require(:form).permit(:description)
  end
end
