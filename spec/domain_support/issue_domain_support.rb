# typed: false
module IssueDomainSupport
  def issue_description(desc)
    Issue::Description.new(desc)
  end

  def acceptance_criterion(content)
    Issue::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
      .yield_self { |contents| Issue::AcceptanceCriteria.new(contents) }
  end

  def issue_list(*issue_ids)
    Issue::List.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include IssueDomainSupport
end
