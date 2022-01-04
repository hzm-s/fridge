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

    sig {params(number: Integer).returns(T.self_type)}
    def start(number)
      update_task_of(number) { |t| t.start }
    end

    sig {params(number: Integer).returns(T.self_type)}
    def complete(number)
      update_task_of(number) { |t| t.complete }
    end

    sig {params(number: Integer).returns(T.self_type)}
    def suspend(number)
      update_task_of(number) { |t| t.suspend }
    end

    sig {params(number: Integer).returns(T.self_type)}
    def resume(number)
      update_task_of(number) { |t| t.resume }
    end

    sig {params(number: Integer, content: Shared::ShortSentence).returns(T.self_type)}
    def modify_content(number, content)
      update_task_of(number) { |t| t.modify(content) }
    end

    sig {params(number: Integer).returns(T.nilable(Task))}
    def of(number)
      @tasks.find { |t| t.number == number }&.deep_dup
    end

    sig {returns(T::Boolean)}
    def empty?
      @tasks.empty?
    end

    sig {returns(T::Array[Task])}
    def to_a
      @tasks.deep_dup
    end

    sig {params(other: TaskList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    private

    sig {params(number: Integer, block: T.proc.params(arg0: Task).void).returns(T.self_type)}
    def update_task_of(number, &block)
      @tasks.deep_dup
        .map { |t| t.number == number ? t.tap { yield(t) } : t }
        .then { |tasks| self.class.new(tasks) }
    end
  end
end
