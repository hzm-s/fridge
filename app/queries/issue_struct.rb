# typed: false

class IssueStruct < SimpleDelegator
  attr_reader :criteria

  def initialize(dao)
    super(dao)
    @criteria = dao.criteria.map { |c| AcceptanceCriterionStruct.new(c) }
  end

  def product_id
    dao_product_id
  end

  def type
    @__type ||= Issue::Types.from_string(issue_type)
  end

  def status
    @__status ||= Issue::Statuses.from_string(super)
  end

  def must_have_acceptance_criteria?
    type.must_have_acceptance_criteria?
  end

  class AcceptanceCriterionStruct < SimpleDelegator
    def issue_id
      dao_issue_id
    end
  end
end
