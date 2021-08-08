# typed: false

class IssueStruct < SimpleDelegator
  attr_reader :product_id, :type, :status

  def initialize(dao)
    super(dao)

    @product_id = dao.dao_product_id
    @criteria = dao.read_acceptance_criteria
    @criterion_structs = dao.criteria.map { |c| AcceptanceCriterionStruct.new(c) }
    @type = Issue::Types.from_string(dao.issue_type)
    @status = Issue::Statuses.from_string(dao.status)
  end

  def criteria
    @criterion_structs
  end

  def must_have_acceptance_criteria?
    type.must_have_acceptance_criteria?
  end

  def can_accept?
    type.can_accept?(@criteria)
  end

  def accept_issue_activity
    type.accept_issue_activity.to_s.to_sym
  end

  class AcceptanceCriterionStruct < SimpleDelegator
    def issue_id
      dao_issue_id
    end
  end
end
