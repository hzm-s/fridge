# typed: ignore
class TaskStatusesController < ApplicationController
  USECASES = {
    start_task: StartTaskUsecase,
    suspend_task: SuspendTaskUsecase,
    resume_task: ResumeTaskUsecase,
    complete_task: CompleteTaskUsecase,
  }

  before_action :require_user

  def update
    pbi_id = Pbi::Id.from_string(params[:pbi_id])
    task_number = params[:number].to_i
    USECASES[params[:by].to_sym].perform(pbi_id, task_number)
    @task = TaskQuery.call(pbi_id.to_s, task_number)
  end
end
