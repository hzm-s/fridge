# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(issue_id: Issue::Id).returns(T.attached_class)}
      def create(issue_id)
        new(issue_id, TaskList.new)
      end
    end

    sig {returns(Issue::Id)}
    attr_reader :issue_id

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(issue_id: Issue::Id, tasks: TaskList).void}
    def initialize(issue_id, tasks)
      @issue_id = issue_id
      @tasks = tasks
    end
  end
end
