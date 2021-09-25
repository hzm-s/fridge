# typed: strict
require 'sorbet-runtime'

module Work
  class TaskList
    extend T::Sig

    sig {params(tasks: T::Array[Task]).void}
    def initialize(tasks = [])
      @tasks = tasks
    end

    sig {params(content: Shared::ShortSentence).returns(T.self_type)}
    def append(content)
      number = (@tasks.last&.number).to_i + 1
      self.class.new(@tasks + [Task.create(number, content)])
    end

    sig {params(number: Integer).returns(T.self_type)}
    def remove(number)
      self.class.new(@tasks.reject { |t| t.number == number })
    end

    sig {params(number: Integer).returns(T.nilable(Task))}
    def of(number)
      @tasks.find { |t| t.number == number }
    end

    sig {returns(T::Boolean)}
    def empty?
      @tasks.empty?
    end

    sig {returns(T::Array[Task])}
    def to_a
      @tasks
    end

    sig {params(other: TaskList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end
  end
end
