# typed: false

class IssueStruct < SimpleDelegator
  def product_id
    dao_product_id
  end

  def type
    @__type ||= Issue::Types.from_string(issue_type)
  end

  def status
    @__status ||= Issue::Statuses.from_string(super)
  end

  def criteria
    @__criteria ||= super.sort_by(&:id)
  end

  def must_have_acceptance_criteria?
    type.must_have_acceptance_criteria?
  end
end
