# typed: false
class IssuesController < ApplicationController
  include ProductHelper

  before_action :require_user

  helper_method :current_product_id

  def index
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = PbiForm.new
  end

  def create
    @form = IssueForm.new(permitted_params)

    if @form.valid?
      AddIssueUsecase.perform(
        Product::Id.from_string(params[:product_id]),
        @form.domain_objects[:description]
      )
      redirect_to product_backlog_path(product_id: params[:product_id]), flash: flash_success('issue.create')
    else
      render :new
    end
  end

  def edit
    @pbi = PbiQuery.call(params[:id])
    @form = PbiForm.new(description: @pbi.description)
  end

  def update
    @pbi_id = params[:id]
    @form = PbiForm.new(permitted_params)

    if @form.valid?
      ModifyPbiUsecase.perform(
        Pbi::Id.from_string(@pbi_id),
        @form.domain_objects[:description]
      )
      redirect_to edit_pbi_path(@pbi_id), flash: flash_success('pbi.update')
    else
      render :edit
    end
  end

  def destroy
    pbi = PbiRepository::AR.find_by_id(Pbi::Id.from_string(params[:id]))
    RemovePbiUsecase.perform(pbi.id)
    redirect_to product_pbis_path(product_id: pbi.product_id), flash: flash_success('pbi.destroy')
  end

  private

  def permitted_params
    params.require(:form).permit(:description)
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    Dao::Pbi.find(params[:id]).product_id
  end
end
