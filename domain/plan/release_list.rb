# typed: strict
require 'sorbet-runtime'

module Plan
  class ReleaseList
    extend T::Sig

    sig {params(releases: T::Array[Release]).void}
    def initialize(releases = [])
      @releases = releases
    end

    sig {params(release: Release).returns(T.self_type)}
    def add(release)
      self.class.new(@releases + [release])
    end

    sig {returns(T::Array[Release])}
    def to_a
      @releases
    end

    sig {params(other: ReleaseList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end
  end
end
