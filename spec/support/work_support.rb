# typed: false
require_relative '../domain_support/work_domain_support'

module WorkSupport
  def plan_task(issue_id, task_contents)
    task_contents.each do |content|
      PlanTaskUsecase.perform(issue_id, s_sentence(content))
    end
  end

  def start_task(issue_id, task_number)
    StartTaskUsecase.perform(issue_id, task_number)
  end

  def suspend_task(issue_id, task_number)
    SuspendTaskUsecase.perform(issue_id, task_number)
  end

  def complete_task(issue_id, task_number)
    CompleteTaskUsecase.perform(issue_id, task_number)
  end
end

RSpec.configure do |c|
  c.include WorkSupport
end
