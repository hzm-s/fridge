# typed: ignore
class SprintBacklogsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user
  before_action :ensure_current_sprint, only: [:show]

  helper_method :current_sprint

  def show
    @sbl = SprintBacklogQuery.call(current_sprint.id)
  end

  private

  def current_product_id
    params[:product_id]
  end

  def ensure_current_sprint
    unless current_sprint
      redirect_to new_sprint_path(product_id: current_product_id)
    end
  end

  def current_sprint
    @__current_sprint ||= SprintRepository::AR.current(Product::Id.from_string(current_product_id))
  end
end
