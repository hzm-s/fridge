class ProductBacklogsController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = IssueForm.new
  end

  def update
    issue_id = Issue::Id.from_string(params[:item])
    to_release_id = Release::Id.from_string(params[:to_release_id])
    AddReleaseItemUsecase.perform(issue_id, to_release_id)
  end

  private

  def current_product_id
    params[:product_id]
  end
end
