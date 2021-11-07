# typed: strict
require 'sorbet-runtime'

module Pbi
  class Types < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        raise InvalidType unless values.map(&:to_s).include?(str)

        deserialize(str)
      end
    end

    enums do
      Feature = new('feature')
      Task = new('task')
      Issue = new('issue')
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
