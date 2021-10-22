# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Accepted
      class << self
        extend T::Sig
        include Status
      end
    end
  end
end
