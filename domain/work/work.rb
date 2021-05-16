# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(issue_id: Issue::Id).returns(T.attached_class)}
      def create(issue_id)
        new(issue_id, [])
      end
    end

    sig {returns(Issue::Id)}
    attr_reader :issue_id

    sig {returns(T::Array[Task])}
    attr_reader :tasks

    sig {params(issue_id: Issue::Id, tasks: T::Array[Task]).void}
    def initialize(issue_id, tasks)
      @issue_id = issue_id
      @tasks = tasks
    end

    sig {params(content: String).void}
    def append_task(content)
      number = (@tasks.last&.number).to_i + 1
      @tasks << Task.new(number, content)
    end

    sig {params(number: Integer).returns(Task)}
    def task_of(number)
      @tasks.find { |t| t.number == number }
    end
  end
end
