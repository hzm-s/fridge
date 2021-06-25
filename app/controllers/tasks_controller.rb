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
    @form = TaskForm.new(task_params)
    @issue_id = Issue::Id.from_string(params[:issue_id])
    task_number = params[:number].to_i

    if @form.valid?
      ModifyTaskUsecase.perform(@issue_id, task_number, @form.content)
      @task = TaskQuery.call(@issue_id.to_s, task_number)
    else
      @task = TaskQuery.call(@issue_id.to_s, task_number)
      render :edit
    end
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
