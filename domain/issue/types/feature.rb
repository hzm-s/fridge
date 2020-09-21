# typed: strict
require 'sorbet-runtime'

module Issue
  module Types
    module Feature
      class << self
        extend T::Sig
        include Type

        sig {override.returns(String)}
        def to_s
          'feature'
        end
      end
    end
  end
end
