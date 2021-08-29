# typed: ignore
class TaskStatusesController < ApplicationController
  USECASES = {
    start_task: StartTaskUsecase,
    suspend_task: SuspendTaskUsecase,
    resume_task: ResumeTaskUsecase,
    complete_task: CompleteTaskUsecase,
  }

  def update
    issue_id = Issue::Id.from_string(params[:issue_id])
    task_number = params[:number].to_i
    USECASES[params[:by].to_sym].perform(issue_id, task_number)
    @task = TaskQuery.call(issue_id.to_s, task_number)
  end
end
