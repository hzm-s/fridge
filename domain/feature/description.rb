# typed: strict
require 'sorbet-runtime'

module Feature
  class Description
    extend T::Sig

    sig {params(value: String).void}
    def initialize(value)
      raise InvalidDescription unless (3..500).include?(value.size)

      @value = value
    end

    sig {returns(String)}
    def to_s
      @value
    end

    sig {params(other: Description).returns(T::Boolean)}
    def ==(other)
      self.to_s == other.to_s
    end
  end
end
