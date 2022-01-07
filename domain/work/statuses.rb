# typed: strict
require 'sorbet-runtime'

module Work
  class Statuses < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      end
    end

    enums do
      Assigned = new('assigned')
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
