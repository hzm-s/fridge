# typed: strict
require 'sorbet-runtime'

module ReleaseRepository
  class AR
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.returns(Integer)}
      def next_number
        Dao::Release.maximum(:number).to_i + 1
      end
    end
  end
end
