# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Wip
      class << self
        extend T::Sig
        include Status

        sig {override.params(pbi: Item).returns(Status)}
        def update_by_prepartion(pbi)
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
