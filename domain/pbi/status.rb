# typed: strict
require 'sorbet-runtime'

module Pbi
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_prepartion(criteria, size); end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
