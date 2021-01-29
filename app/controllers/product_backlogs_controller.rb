# typed: false
class ProductBacklogsController < ApplicationController
  include ProductHelper

  helper_method :current_product_id, :can_update_release_plan?

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = IssueForm.new
  end

  private

  def current_product_id
    params[:product_id]
  end

  def can_update_release_plan?
    current_product_team_member(current_user.person_id)
      .roles
      .can_update_release_plan?
  end
end
