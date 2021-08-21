# typed: strict
require 'sorbet-runtime'

module Activity
  class Set
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(symbols: T::Array[Symbol]).returns(T.attached_class)}
      def from_symbols(symbols)
        symbols
          .map { |sym| Activity.from_string(sym.to_s) }
          .then { |entries| new(entries) }
      end
    end

    sig {params(entries: T::Array[Activity]).void}
    def initialize(entries)
      @entries = T.let(entries.to_set, T::Set[Activity])
    end

    sig {params(other: Set).returns(T.self_type)}
    def &(other)
      self.class.new((entries & other.entries).to_a)
    end

    sig {params(other: Set).returns(T.self_type)}
    def +(other)
      self.class.new((entries + other.entries).to_a)
    end

    sig {params(entry: Activity).returns(T::Boolean)}
    def include?(entry)
      entries.include?(entry)
    end

    sig {params(other: Set).returns(T::Boolean)}
    def ==(other)
      self.entries == other.entries
    end

    protected

    sig {returns(T::Set[Activity])}
    attr_reader :entries
  end
end
