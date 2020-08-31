# typed: strict
require 'sorbet-runtime'

module TeamRepository
  module AR
    class << self
      extend T::Sig
      include Team::TeamRepository

      sig {override.params(id: Team::Id).returns(Team::Team)}
      def find_by_id(id)
        r = Dao::Team.find(id)
        members = r.members.map do |m|
          Team::Member.new(
            Person::Id.from_string(m.dao_person_id),
            Team::Role.from_string(m.role)
          )
        end
        Team::Team.from_repository(Team::Id.from_string(r.id), r.name, members)
      end

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
