# typed: strict
require 'sorbet-runtime'

module Pbi
  class Content
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(content: String).returns(T.attached_class)}
      def from_repository(content)
        raise ArgumentError unless (3..500).include?(content.size)
        new(content)
      end
      alias_method :from_string, :from_repository
    end

    sig {params(value: String).void}
    def initialize(value)
      @value = value
    end
    private_class_method :new

    sig {returns(String)}
    def to_s
      @value
    end
  end
end
