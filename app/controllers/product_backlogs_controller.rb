# typed: false
class ProductBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  helper_method :current_product_id

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = IssueForm.new
  end

  private

  def current_product_id
    params[:product_id]
  end
end
