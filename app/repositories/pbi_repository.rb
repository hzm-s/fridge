# typed: strict
require 'sorbet-runtime'

module PbiRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::PbiRepository

      sig {override.params(pbi: Pbi::Pbi).void}
      def store(pbi)
        Dao::Pbi.find_or_initialize_by(id: pbi.id.to_s).tap do |dao|
          dao.write(pbi)
          dao.save!
        end
      end
    end
  end
end
