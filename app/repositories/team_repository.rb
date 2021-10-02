# typed: strict
require 'sorbet-runtime'

module TeamRepository
  module AR
    class << self
      extend T::Sig
      include Team::TeamRepository

      sig {override.params(id: Team::Id).returns(Team::Team)}
      def find_by_id(id)
        Dao::Team.as_aggregate.find(id).read
      end

      sig {override.params(team: Team::Team).void}
      def store(team)
        dao = Dao::Team.find_or_initialize_by(id: team.id.to_s)
        dao.write(team)
        dao.save!
      end
    end
  end
end
