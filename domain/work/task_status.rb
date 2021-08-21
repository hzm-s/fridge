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
      activities = [next_activity]
      activities << Activity::Activity.from_symbol(:update_task) unless self == Done
      activities << Activity::Activity.from_symbol(:suspend_task) if self == Wip
      Activity::Set.new(activities.compact)
    end

    sig {returns(T.nilable(Activity::Activity))}
    def next_activity
      case self
      when Todo
        Activity::Activity.from_symbol(:start_task)
      when Wip
        Activity::Activity.from_symbol(:complete_task)
      when Wait
        Activity::Activity.from_symbol(:resume_task)
      else
        nil
      end
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
