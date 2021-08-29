# typed: ignore
class ProductBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = CreateIssueForm.new
  end

  private

  def current_product_id
    params[:product_id]
  end
end
