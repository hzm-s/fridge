# typed: strict
require 'sorbet-runtime'

module Work
  class TaskStatus < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      rescue KeyError => e
        raise InvalidTaskStatus
      end
    end

    enums do
      Todo = new('todo')
      Wip = new('wip')
      Done = new('done')
    end

    sig {returns(T.self_type)}
    def start
      raise TaskIsDone unless self == Todo

      Wip
    end

    sig {returns(T.self_type)}
    def complete
      raise TaskIsNotStarted unless self == Wip

      Done
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
