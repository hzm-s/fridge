# typed: false
class ReleasesController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def new
    @form = ReleaseForm.new
  end

  def create
    @form = ReleaseForm.new(permitted_params)
    if @form.valid?
      roles = current_team_member(current_user.person_id).roles
      begin
        AppendReleaseUsecase.perform(
          roles,
          Product::Id.from_string(current_product_id),
          @form.name
        )
      rescue Plan::DuplicatedReleaseName => e
        @form.errors.add(:name, t_domain_error(e.class))
        render :edit
      else
        redirect_to product_backlog_path(product_id: current_product_id), flash: flash_success('release.create')
      end
    else
      render :new
    end
  end

  def edit
    @form = ReleaseForm.new(name: current_release.name, index: release_index)
  end

  def update
    @form = ReleaseForm.new(name: params[:form][:name], index: release_index)
    if @form.valid?
      roles = current_team_member(current_user.person_id).roles
      begin
        ChangeReleaseNameUsecase.perform(
          Product::Id.from_string(current_product_id),
          roles,
          @form.name,
          current_release.name
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
    roles = current_team_member(current_user.person_id).roles
    RemoveReleaseUsecase.perform(
      Product::Id.from_string(current_product_id),
      roles,
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
    params.require(:form).permit(:name)
  end
end
