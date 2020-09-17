# typed: false
class IssuesController < ApplicationController
  include ProductHelper

  before_action :require_user

  helper_method :current_product_id

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
    @issue = IssueQuery.call(params[:id])
    @form = IssueForm.new(description: @issue.description)
  end

  def update
    @issue_id = params[:id]
    @form = IssueForm.new(permitted_params)

    if @form.valid?
      ModifyIssueUsecase.perform(
        Issue::Id.from_string(@issue_id),
        @form.domain_objects[:description]
      )
      redirect_to edit_issue_path(@issue_id), flash: flash_success('issue.update')
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

    IssueQuery.call(params[:id]).product_id
  end
end
