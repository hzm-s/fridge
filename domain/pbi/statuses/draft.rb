# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Draft
      class << self
        extend T::Sig
        include Status

        sig {override.params(pbi: Item).returns(Status)}
        def update_by(pbi)
          return Preparation if pbi.have_acceptance_criteria? && pbi.size_estimated?
          self
        end

        sig {override.returns(String)}
        def to_s
          'draft'
        end
      end
    end
  end
end
