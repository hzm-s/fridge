# typed: strict
require 'sorbet-runtime'

module Plan
  class ReleaseSequence
    extend T::Sig

    sig {params(value: Integer).void}
    def initialize(value)
      raise ArgumentError unless (0..20).include?(value)

      @value = value
    end
  end
end
