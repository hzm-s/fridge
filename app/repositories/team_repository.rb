# typed: strict
require 'sorbet-runtime'

module TeamRepository
  module AR
    class << self
      extend T::Sig
      include Team::TeamRepository

      sig {override.params(team: Team::Team).void}
      def add(team)
        r = Dao::Team.new(id: team.id.to_s, name: team.name)
        r.members = build_members(team.members)
        r.save!
      end

      sig {override.params(team: Team::Team).void}
      def update(team)
        r = Dao::Team.find(team.id)
        r.members.clear
        r.members = build_members(team.members)
        r.save!
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
