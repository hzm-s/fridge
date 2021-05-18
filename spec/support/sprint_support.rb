# typed: false
module SprintSupport
  def start_sprint(product_id)
    StartSprintUsecase.perform(product_id)
      .then { |id| SprintRepository::AR.find_by_id(id) }
  end

  def plan_task(issue_id, task_contents)
    task_contents.each do |content|
      PlanTaskUsecase.perform(issue_id, content)
    end
  end
end

RSpec.configure do |c|
  c.include SprintSupport
end
