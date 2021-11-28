# typed: strict
require 'sorbet-runtime'

module Sbi
  class Sbi
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi_id: Pbi::Id).returns(T.attached_class)}
      def plan(pbi_id)
        new(Id.create, pbi_id, Work::TaskList.new)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Pbi::Id)}
    attr_reader :pbi_id

    sig {returns(Work::TaskList)}
    attr_reader :tasks

    sig {params(id: Id, pbi_id: Pbi::Id, tasks: Work::TaskList).void}
    def initialize(id, pbi_id, tasks)
      @id = id
      @pbi_id = pbi_id
      @tasks = tasks
    end
  end
end
