class TasksController < ApplicationController
  def create
    @issue_id = Issue::Id.from_string(params[:issue_id])
    @form = TaskForm.new(task_params)

    if @form.valid?
      PlanTaskUsecase.perform(@issue_id, @form.content)

      @form = @form.renew
      @task = Dao::Work.find_by(dao_issue_id: @issue_id.to_s).tasks.last
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:form).permit(:content)
  end
end
