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
    sbi_id = Pbi::Id.from_string(params[:sbi_id])
    task_number = params[:number].to_i
    USECASES[params[:by].to_sym].perform(sbi_id, task_number)
    @task = TaskQuery.call(sbi_id.to_s, task_number)
  end
end
