class SprintsController < ApplicationController
  def create
    StartSprintUsecase.perform(Product::Id.from_string(params[:product_id]))
  end
end
