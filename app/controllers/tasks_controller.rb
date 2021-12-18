# typed: ignore
class TasksController < ApplicationController
  before_action :require_user

  def create
    @pbi_id = Pbi::Id.from_string(params[:pbi_id])
    @form = TaskForm.new(task_params)

    if @form.valid?
      PlanTaskUsecase.perform(@pbi_id, @form.domain_objects[:content])

      @form = @form.renew
      @tasks = TaskListQuery.call(@pbi_id.to_s)
    else
      render :new
    end
  end

  def update
    @form = TaskForm.new(task_params)
    @pbi_id = Pbi::Id.from_string(params[:pbi_id])
    task_number = params[:number].to_i

    if @form.valid?
      ModifyTaskUsecase.perform(@pbi_id, task_number, @form.domain_objects[:content])
      @task = TaskQuery.call(@pbi_id.to_s, task_number)
    else
      @task = TaskQuery.call(@pbi_id.to_s, task_number)
      render :edit
    end
  end

  def destroy
    @pbi_id = Pbi::Id.from_string(params[:pbi_id])
    DropTaskUsecase.perform(@pbi_id, params[:number].to_i)
    @tasks = TaskListQuery.call(@pbi_id.to_s)
  end

  private

  def task_params
    params.require(:form).permit(:content)
  end
end
