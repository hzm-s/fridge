# typed: strict
require 'sorbet-runtime'

module Requirement
  module Kinds
    module Feature
      class << self
        extend T::Sig
        include Kind

        sig {override.returns(String)}
        def to_s
          'feature'
        end
      end
    end
  end
end
