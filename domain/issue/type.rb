# typed: strict
require 'sorbet-runtime'
require 'issue/status'

module Issue
  module Type
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Status)}
    def initial_status; end

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(T::Boolean)}
    def prepared?(criteria, size); end

    sig {abstract.returns(T::Array[Activity::Activity])}
    def acceptance_activities; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
