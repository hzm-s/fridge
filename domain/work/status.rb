# typed: strict
require 'sorbet-runtime'

module Work
  class Status < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      rescue KeyError => e
        raise InvalidStatus
      end
    end

    enums do
      NotAccepted = new('not_accepted')
      Acceptable = new('acceptable')
      Accepted = new('accepted')
    end

    sig {params(current: T::Set[Integer], master: Issue::AcceptanceCriteria).returns(T.self_type)}
    def update(current, master)
      case self
      when NotAccepted
        update_when_not_accepted(current, master)
      when Acceptable
        update_when_acceptable(current, master)
      else
        raise InvalidStatus
      end
    end

    sig {returns(String)}
    def to_s
      serialize
    end

    private

    sig {params(current: T::Set[Integer], master: Issue::AcceptanceCriteria).returns(T.self_type)}
    def update_when_not_accepted(current, master)
      return self unless current.size == master.size

      Acceptable
    end

    sig {params(current: T::Set[Integer], master: Issue::AcceptanceCriteria).returns(T.self_type)}
    def update_when_acceptable(current, master)
      return self if current.size == master.size

      NotAccepted
    end
  end
end
