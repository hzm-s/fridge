# typed: false
class TaskStruct < SimpleDelegator
  attr_reader :issue_id

  def initialize(issue_id, task)
    super(task)
    @issue_id = issue_id
  end

  def available_activities
    Work::TaskStatus.from_string(status).available_activities.to_a.map(&:to_s)
  end
end
