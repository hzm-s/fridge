# typed: false
module FeatureDomainSupport
  def _acceptance_criterion(content)
    Feature::AcceptanceCriterion.new(content)
  end
end

RSpec.configure do |c|
  c.include FeatureDomainSupport
end
