# typed: strict
require 'sorbet-runtime'

module Sprint
  class Sprint
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, number: Integer).returns(T.attached_class)}
      def start(product_id, number)
        new(Id.create, product_id, number, false)
      end

      sig {params(id: Id, product_id: Product::Id, number: Integer, is_finished: T::Boolean).returns(T.attached_class)}
      def from_repository(id, product_id, number, is_finished)
        new(id, product_id, number, is_finished)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Integer)}
    attr_reader :number

    sig {params(id: Id, product_id: Product::Id, number: Integer, is_finished: T::Boolean).void}
    def initialize(id, product_id, number, is_finished)
      @id = id
      @product_id = product_id
      @number = number
      @is_finished = is_finished
    end

    sig {returns(T::Boolean)}
    def finished?
      @is_finished
    end

    sig {void}
    def finish
      raise AlreadyFinished if finished?

      @is_finished = true
    end
  end
end
