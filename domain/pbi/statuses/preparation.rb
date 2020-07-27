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
          self
        end

        sig {override.returns(String)}
        def to_s
          'preparation'
        end
      end
    end
  end
end
