# typed: strict
require 'sorbet-runtime'

module SbiRepository
  class AR
    class << self
      extend T::Sig
      include Sbi::SbiRepository

      sig {override.params(id: Sbi::Id).returns(Sbi::Sbi)}
      def find_by_id(id)
        Dao::Sbi.find(id.to_s).read
      rescue ActiveRecord::RecordNotFound
        raise Sbi::NotFound
      end

      sig {override.params(pbi_id: Pbi::Id).returns(Sbi::Sbi)}
      def find_by_pbi_id(pbi_id)
        Dao::Sbi.find_by!(dao_pbi_id: pbi_id.to_s).read
      end

      sig {override.params(pbi_id: Pbi::Id).returns(Sbi::Id)}
      def resolve_id(pbi_id)
        Dao::Sbi.select(:id).find_by!(dao_pbi_id: pbi_id.to_s).id
          .then { |id| Sbi::Id.from_string(id) }
      end

      sig {override.params(sbi: Sbi::Sbi).void}
      def store(sbi)
        dao = Dao::Sbi.new(id: sbi.id.to_s)
        dao.write(sbi)
        dao.save!
      end

      sig {override.params(id: Sbi::Id).void}
      def remove(id)
        Dao::Sbi.destroy(id.to_s)
      end
    end
  end
end
