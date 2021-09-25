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
      if current.size == master.size
        return Acceptable
      else
        self
      end
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
