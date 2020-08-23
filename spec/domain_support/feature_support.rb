# typed: false
module FeatureDomainSupport
  def acceptance_criterion(content)
    Feature::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
  end
end

RSpec.configure do |c|
  c.include FeatureDomainSupport
end
