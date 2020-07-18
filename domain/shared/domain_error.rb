# typed: true
module Shared
  class DomainError < StandardError
    def initialize(origin)
      super()
      @origin = origin
    end
  end
end
