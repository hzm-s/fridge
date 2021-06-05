# typed: false
class TaskStruct < SimpleDelegator
  attr_reader :issue_id

  def initialize(issue_id, task)
    super(task)
    @issue_id = issue_id
  end
end
