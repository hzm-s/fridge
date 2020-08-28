# typed: false
module PbiDomainSupport
  def feature_description(desc)
    Pbi::Description.new(desc)
  end

  def acceptance_criterion(content)
    Pbi::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
      .yield_self { |contents| Pbi::AcceptanceCriteria.new(contents) }
  end
end

RSpec.configure do |c|
  c.include PbiDomainSupport
end
