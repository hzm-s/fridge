# typed: false

module WorkSupport
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
