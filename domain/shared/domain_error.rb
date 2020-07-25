# typed: true
module Shared
  class DomainError < StandardError
    def initialize(origin = nil)
      super()
      @origin = origin
    end
  end
end
