# typed: strict
require 'sorbet-runtime'

module Activity
  class Set
    extend T::Sig

    Entry = T.type_alias {Symbol}
    EntryList = T.type_alias {T::Array[Entry]}
    EntrySet = T.type_alias {T::Set[Entry]}

    sig {params(entries: EntryList).void}
    def initialize(entries)
      @entries = entries.to_set
    end

    sig {params(other: Activity::Set).returns(T.self_type)}
    def &(other)
      self.class.new((entries & other.entries).to_a)
    end

    sig {params(entry: Entry).returns(T::Boolean)}
    def allow?(entry)
      entries.include?(entry)
    end

    protected

    sig {returns(EntrySet)}
    attr_reader :entries
  end
end
