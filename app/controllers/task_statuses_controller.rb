class TaskStatusesController < ApplicationController
  USECASES = {
    'start' => StartTaskUsecase,
    'suspend' => SuspendTaskUsecase,
    'resume' => ResumeTaskUsecase,
    'complete' => CompleteTaskUsecase,
  }

  def update
    issue_id = Issue::Id.from_string(params[:issue_id])
    task_number = params[:number].to_i
    USECASES[params[:type]].perform(issue_id, task_number)
    @task = TaskQuery.call(issue_id.to_s, task_number)
  end
end
