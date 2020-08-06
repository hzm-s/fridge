# typed: false
module PbiDomainSupport
  def acceptance_criterion(content)
    Pbi::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
      .yield_self { |criteria| Pbi::AcceptanceCriteria.new(criteria) }
  end
end

RSpec.configure do |c|
  c.include PbiDomainSupport
end
