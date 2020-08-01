# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Wip
      class << self
        extend T::Sig
        include Status

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_prepartion(criteria, size)
          self
        end

        sig {override.returns(String)}
        def to_s
          'wip'
        end
      end
    end
  end
end
