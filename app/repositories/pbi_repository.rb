# typed: strict
require 'sorbet-runtime'

module PbiRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::PbiRepository

      sig {override.params(id: Pbi::Id).returns(Pbi::Pbi)}
      def find_by_id(id)
        Dao::Pbi.as_aggregate.find(id.to_s).read
      end

      sig {override.params(pbi: Pbi::Pbi).void}
      def store(pbi)
        Dao::Pbi.find_or_initialize_by(id: pbi.id.to_s).tap do |dao|
          dao.write(pbi)
          dao.save!
        end
      end

      sig {override.params(id: Pbi::Id).void}
      def remove(id)
        Dao::Pbi.destroy(id.to_s)
      end
    end
  end
end
