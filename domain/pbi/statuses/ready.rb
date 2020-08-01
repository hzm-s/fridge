# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Ready
      class << self
        extend T::Sig
        include Status

        sig {override.params(pbi: Item).returns(Status)}
        def update_by_prepartion(pbi)
          if pbi.acceptance_criteria.size >= 1 && pbi.size != StoryPoint.unknown
            self
          else
            Preparation
          end
        end

        sig {override.returns(String)}
        def to_s
          'ready'
        end
      end
    end
  end
end
