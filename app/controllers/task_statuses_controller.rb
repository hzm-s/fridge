class TaskStatusesController < ApplicationController
  USECASES = {
    'start' => StartTaskUsecase,
    'suspend' => SuspendTaskUsecase,
    'complete' => CompleteTaskUsecase,
  }

  def update
    @issue_id = Issue::Id.from_string(params[:issue_id])
    USECASES[params[:type]].perform(@issue_id, params[:number].to_i)
    @tasks = TaskListQuery.call(@issue_id.to_s)
  end
end
