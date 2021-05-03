class SprintsController < ApplicationController
  def create
    StartSprintUsecase.perform(Product::Id.from_string(params[:product_id]))
  rescue Sprint::AlreadyStarted
  ensure
    redirect_to sprint_backlog_path(params[:product_id])
  end
end
