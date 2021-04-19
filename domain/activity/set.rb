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

    EntryList = T.type_alias {T::Array[Activity]}
    EntrySet = T.type_alias {T::Set[Activity]}

    sig {params(entries: EntryList).void}
    def initialize(entries)
      @entries = entries.to_set
    end

    sig {params(other: Set).returns(T.self_type)}
    def &(other)
      self.class.new((entries & other.entries).to_a)
    end

    sig {params(entry: Activity).returns(T::Boolean)}
    def allow?(entry)
      entries.include?(entry)
    end

    sig {params(other: Set).returns(T::Boolean)}
    def ==(other)
      self.entries == other.entries
    end

    protected

    sig {returns(EntrySet)}
    attr_reader :entries
  end
end
