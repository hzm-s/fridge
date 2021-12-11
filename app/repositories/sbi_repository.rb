# typed: strict
require 'sorbet-runtime'

module SbiRepository
  class AR
    class << self
      extend T::Sig
      include Sbi::SbiRepository

      sig {override.params(id: Pbi::Id).returns(Sbi::Sbi)}
      def find_by_id(id)
        Dao::Sbi.find_by!(dao_pbi_id: id.to_s).read
      rescue ActiveRecord::RecordNotFound
        raise Sbi::NotFound
      end

      sig {override.params(sbi: Sbi::Sbi).void}
      def store(sbi)
        Dao::Sbi.find_or_initialize_by(dao_pbi_id: sbi.id.to_s).tap do |dao|
          dao.write(sbi)
          dao.save!
        end
      end

      sig {override.params(id: Pbi::Id).void}
      def remove(id)
        Dao::Sbi.destroy(id.to_s)
      end
    end
  end
end
