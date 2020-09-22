# typed: false

class IssueStruct < SimpleDelegator
  def type
    @__type ||= Issue::Types.from_string(issue_type)
  end

  def status
    @__status ||= Issue::Statuses.from_string(super)
  end

  def criteria
    @__criteria ||= super.sort_by(&:id)
  end
end
