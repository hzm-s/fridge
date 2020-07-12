# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriteria
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(T.attached_class)}
      def create
        new([])
      end

      sig {params(list: T::Array[String]).returns(T.attached_class)}
      def from_repository(list)
        new(list)
      end
    end

    sig {params(list: T::Array[String]).void}
    def initialize(list)
      @criterion_list = list
    end
    private_class_method :new

    sig {params(content: String).void}
    def add(content)
      @criterion_list << content
    end

    sig {params(no: Integer).returns(T.nilable(String))}
    def get(no)
      @criterion_list[no_to_index(no)]
    end

    sig {returns(T::Boolean)}
    def empty?
      true
    end

    sig {returns(T::Array[String])}
    def to_a
      @criterion_list
    end

    private

    sig {params(no: Integer).returns(Integer)}
    def no_to_index(no)
      no - 1
    end
  end
end
