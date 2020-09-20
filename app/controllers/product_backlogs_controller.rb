# typed: false
class ProductBacklogsController < ApplicationController
  include ProductHelper

  helper_method :current_product_id

  def show
    @pbl = ProductBacklogQuery.call(params[:product_id])
    @form = IssueForm.new
  end

  def update
    ManageReleaseItemUsecase.perform(
      item,
      from_release_id,
      to_release_id,
      new_index
    )
  end

  private

  def item
    Issue::Id.from_string(params[:item])
  end

  def from_release_id
    return nil unless id = params[:from_release_id]
    Release::Id.from_string(id)
  end

  def to_release_id
    return nil unless id = params[:to_release_id]
    Release::Id.from_string(id)
  end

  def new_index
    params[:new_index].to_i
  end

  def current_product_id
    params[:product_id]
  end
end
