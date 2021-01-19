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

    sig {returns(T::Boolean)}
    def can_estimate_issue?
      self == Developer
    end

    sig {returns(T::Boolean)}
    def can_change_issue_priority?
      [ProductOwner, ScrumMaster].include?(self)
    end

    sig {returns(T::Array[Symbol])}
    def denied_actions
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
