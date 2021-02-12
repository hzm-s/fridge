# typed: false
class ProductBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  helper_method :current_product_id, :can_update_release_plan?, :can_estimate_issue?

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = IssueForm.new
  end

  private

  def current_product_id
    params[:product_id]
  end

  def current_team_member_roles
    @__current_team_member_roles ||= current_team_member(current_user.person_id).roles
  end

  def can_update_release_plan?
    current_team_member_roles.can_update_release_plan?
  end

  def can_estimate_issue?
    current_team_member_roles.can_estimate_issue?
  end
end
