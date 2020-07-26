# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Draft
      class << self
        extend T::Sig
        include Status

        sig {override.params(pbi: Item).returns(Status)}
        def change(pbi)
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
