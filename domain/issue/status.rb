# typed: strict
require 'sorbet-runtime'

module Issue
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(T::Boolean)}
    def can_remove?; end

    sig {abstract.returns(T::Boolean)}
    def can_estimate?; end

    sig {abstract.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_prepartion(type, criteria, size); end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
