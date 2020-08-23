# typed: false
module FeatureDomainSupport
  def acceptance_criterion(content)
    Feature::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
      .yield_self { |contents| Feature::AcceptanceCriteria.new(contents) }
  end
end

RSpec.configure do |c|
  c.include FeatureDomainSupport
end
