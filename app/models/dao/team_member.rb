# typed: strict
class Dao::TeamMember < ApplicationRecord
  belongs_to :team, class_name: 'Dao::Team', foreign_key: :dao_team_id, optional: true
  belongs_to :person, class_name: 'Dao::Person', foreign_key: :dao_person_id

  def read
    Team::Member.new(
      read_person_id,
      read_roles
    )
  end

  private

  def read_person_id
    Person::Id.from_string(dao_person_id)
  end

  def read_roles
    roles.map { |r| Team::Role.from_string(r) }
      .then { |rs| Team::RoleSet.new(rs) }
  end
end
