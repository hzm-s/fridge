# typed: strong

require 'sorbet-runtime'

module Product
  class BacklogItemContent
    extend T::Sig

    sig {params(value: String).void}
    def initialize(value)
      @value = value
    end

    sig {returns(String)}
    def to_s
      @value
    end
  end
end
