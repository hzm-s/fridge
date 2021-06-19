class CompleteTasksController < ApplicationController
  def create
    @issue_id = Issue::Id.from_string(params[:issue_id])
    CompleteTaskUsecase.perform(@issue_id, params[:number].to_i)
    @tasks = TaskListQuery.call(@issue_id.to_s)
  end
end
