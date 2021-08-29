# typed: ignore
class IssuesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  helper_method :current_product_id

  def create
    @form = CreateIssueForm.new(create_params)

    if @form.valid?
      product_id = Product::Id.from_string(params[:product_id])
      type = @form.domain_objects[:type]
      description = @form.domain_objects[:description]
      release_number = @form.release_number&.to_i

      PlanIssueUsecase.perform(product_id, type, description, release_number)

      redirect_to product_backlog_path(product_id: params[:product_id]), flash: flash_success('issue.create')
    else
      @releases = ProductBacklogQuery.call(params[:product_id]).releases
      render :new
    end
  end

  def edit
    @issue = IssueQuery.call(params[:id])
    @form = UpdateIssueForm.new(type: @issue.type.to_s, description: @issue.description.to_s)
  end

  def update
    @issue_id = params[:id]
    @form = UpdateIssueForm.new(update_params)

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
    issue = IssueRepository::AR.find_by_id(Issue::Id.from_string(params[:id]))
    DropIssueUsecase.perform(issue.product_id, current_team_member_roles, issue.id)
    redirect_to product_backlog_path(product_id: issue.product_id), flash: flash_success('issue.destroy')
  end

  private

  def create_params
    params.require(:form).permit(:type, :description, :release_number)
  end

  def update_params
    params.require(:form).permit(:description)
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    IssueQuery.call(params[:id]).product_id
  end
end
