# typed: strict
require 'sorbet-runtime'

module Team
  class Role < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      rescue KeyError => e
        raise InvalidRole
      end
    end

    enums do
      ProductOwner = new('product_owner')
      Developer = new('developer')
      ScrumMaster = new('scrum_master')
    end

    sig {returns(T::Array[Symbol])}
    def unavailable_actions_for_pbi
      case self
      when ProductOwner
        [:estimate_size]
      when Developer
        [:sort]
      when ScrumMaster
        [:estimate_size]
      else
        T.absurd(self)
      end
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
