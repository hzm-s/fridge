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
      Wait = new('wait')
      Done = new('done')
    end

    sig {returns(T.self_type)}
    def start
      raise InvalidTaskStatusUpdate unless self == Todo

      Wip
    end

    sig {returns(T.self_type)}
    def complete
      raise InvalidTaskStatusUpdate unless self == Wip

      Done
    end

    sig {returns(T.self_type)}
    def suspend
      raise InvalidTaskStatusUpdate unless self == Wip

      Wait
    end

    sig {returns(T.self_type)}
    def resume
      raise InvalidTaskStatusUpdate unless self == Wait

      Wip
    end

    sig {returns(Activity::Set)}
    def available_activities
      activities =
        case self
        when Todo
          [:start_task]
        when Wip
          [:complete_task, :suspend_task]
        when Wait
          [:resume_task]
        else
          []
        end
      Activity::Set.from_symbols(activities)
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
