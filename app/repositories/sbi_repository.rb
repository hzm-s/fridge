# typed: strict
require 'sorbet-runtime'

module SbiRepository
  class AR
    class << self
      extend T::Sig
      include Sbi::SbiRepository

      sig {override.params(pbi_id: Pbi::Id).returns(Sbi::Sbi)}
      def find_by_pbi_id(pbi_id)
        Dao::Sbi.find_by!(dao_pbi_id: pbi_id.to_s).read
      end

      sig {override.params(sbi: Sbi::Sbi).void}
      def store(sbi)
        dao = Dao::Sbi.new(id: sbi.id.to_s)
        dao.write(sbi)
        dao.save!
      end
    end
  end
end
