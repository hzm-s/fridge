class TasksController < ApplicationController
  def create
    @issue_id = Issue::Id.from_string(params[:issue_id])
    PlanTaskUsecase.perform(@issue_id, create_params[:content])
    @task = Dao::Work.find_by(dao_issue_id: @issue_id.to_s).tasks.last
  end

  private

  def create_params
    params.require(:form).permit(:content)
  end
end
