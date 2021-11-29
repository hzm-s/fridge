# typed: strict
require 'sorbet-runtime'

module SbiRepository
  class AR
    class << self
      extend T::Sig
      include Sbi::SbiRepository

      sig {override.params(sbi: Sbi::Sbi).void}
      def store(sbi)
        dao = Dao::Sbi.new(id: sbi.id.to_s)
        dao.write(sbi)
        dao.save!
      end
    end
  end
end
