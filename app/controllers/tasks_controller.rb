class TasksController < ApplicationController
  def create
    @issue_id = Issue::Id.from_string(params[:issue_id])
    @form = TaskForm.new(task_params)

    if @form.valid?
      PlanTaskUsecase.perform(@issue_id, @form.content)

      @form = @form.renew
      @tasks = TaskListQuery.call(@issue_id.to_s)
    else
      render :new
    end
  end

  def update
    @issue_id = Issue::Id.from_string(params[:issue_id])
    @form = TaskForm.new(task_params)
    ModifyTaskUsecase.perform(@issue_id, params[:number].to_i, @form.content)
    @tasks = TaskListQuery.call(@issue_id.to_s)
  end

  def destroy
    @issue_id = Issue::Id.from_string(params[:issue_id])
    DropTaskUsecase.perform(@issue_id, params[:number].to_i)
    @tasks = TaskListQuery.call(@issue_id.to_s)
  end

  private

  def task_params
    params.require(:form).permit(:content)
  end
end
