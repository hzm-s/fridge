# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Preparation
      class << self
        extend T::Sig
        include Status

        sig {override.params(pbi: Item).returns(Status)}
        def update_by(pbi)
          if pbi.acceptance_criteria.size > 0 && pbi.size != StoryPoint.unknown
            Ready
          else
            self
          end
        end

        sig {override.returns(String)}
        def to_s
          'preparation'
        end
      end
    end
  end
end
