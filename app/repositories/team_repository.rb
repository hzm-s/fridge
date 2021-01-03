# typed: strict
require 'sorbet-runtime'

module TeamRepository
  module AR
    class << self
      extend T::Sig
      include Team::TeamRepository

      sig {override.params(id: Team::Id).returns(Team::Team)}
      def find_by_id(id)
        Dao::Team.eager_load(:members).find(id).read
      end

      sig {override.params(product_id: Product::Id).returns(T::Array[Team::Team])}
      def find_all_by_product_id(product_id)
        Dao::Team.eager_load(:members)
          .where(dao_product_id: product_id.to_s)
          .map(&:read)
      end

      sig {override.params(team: Team::Team).void}
      def store(team)
        dao = Dao::Team.find_or_initialize_by(id: team.id.to_s)
        dao.write(team)
        dao.save!
      end

      private

      sig {params(members: Team::Team::Members).returns(T::Array[Dao::TeamMember])}
      def build_members(members)
        members.map do |m|
          Dao::TeamMember.new(dao_person_id: m.person_id.to_s, role: m.role.to_s)
        end
      end
    end
  end
end
