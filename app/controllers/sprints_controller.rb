# typed: ignore
class SprintsController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def create
    StartSprintUsecase.perform(Product::Id.from_string(params[:product_id]))
  rescue Sprint::AlreadyStarted
  ensure
    redirect_to sprint_backlog_path(params[:product_id])
  end

  private

  def current_product_id
    params[:product_id]
  end
end
