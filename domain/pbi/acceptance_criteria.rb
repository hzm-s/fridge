# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriteria
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(T.attached_class)}
      def create
        new(1, [])
      end

      sig {params(next_no: Integer, list: T::Array[AcceptanceCriterion]).returns(T.attached_class)}
      def from_repository(next_no, list)
        new(next_no, list)
      end
    end

    sig {returns(Integer)}
    attr_reader :next_no

    sig {returns(T::Array[AcceptanceCriterion])}
    attr_reader :list

    sig {params(next_no: Integer, list: T::Array[AcceptanceCriterion]).void}
    def initialize(next_no, list)
      @next_no = next_no
      @list = list
    end
    private_class_method :new

    sig {params(content: String).void}
    def add(content)
      @list << AcceptanceCriterion.create(@next_no, content)
      @next_no += 1
    end

    sig {params(no: Integer).void}
    def remove(no)
      raise ArgumentError unless @list.find { |c| c.no == no }
      @list.delete_if { |c| c.no == no }
    end

    sig {returns(T::Boolean)}
    def empty?
      @list.empty?
    end

    sig {returns(T::Array[AcceptanceCriterion::Serialized])}
    def to_a
      @list.map(&:to_h)
    end
  end
end
