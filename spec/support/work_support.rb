# typed: false

module WorkSupport
  def plan_task(issue_id, task_contents)
    task_contents.each do |content|
      PlanTaskUsecase.perform(issue_id, content)
    end
  end

  def start_task(issue_id, task_number)
    StartTaskUsecase.perform(issue_id, task_number)
  end

  def suspend_task(issue_id, task_number)
    SuspendTaskUsecase.perform(issue_id, task_number)
  end
end

RSpec.configure do |c|
  c.include WorkSupport
end
