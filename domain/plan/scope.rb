# typed: strict
require 'sorbet-runtime'

module Plan
  class Scope
    extend T::Sig

    sig {params(release_id: String, tail_index: Integer).void}
    def initialize(release_id, tail_index)
      @release_id = release_id
      @tail_index = tail_index
    end

    def make_release(order, previous)
      Release.new(@release_id, order.to_a[head_index(order, previous)..@tail_index])
    end

    private

    def head_index(order, previous)
      return 0 unless previous
      order.index(previous.tail_index) - 1
    end
  end
end
