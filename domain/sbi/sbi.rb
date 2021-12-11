# typed: strict
require 'sorbet-runtime'

module Sbi
  class Sbi
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi_id: Pbi::Id).returns(T.attached_class)}
      def plan(pbi_id)
        new(pbi_id, TaskList.new)
      end

      sig {params(id: Pbi::Id, tasks: TaskList).returns(T.attached_class)}
      def from_repository(id, tasks)
        new(id, tasks)
      end
    end

    sig {returns(Pbi::Id)}
    attr_reader :id

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(id: Pbi::Id, tasks: TaskList).void}
    def initialize(id, tasks)
      @id = id
      @tasks = tasks
    end
  end
end
