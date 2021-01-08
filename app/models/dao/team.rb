# typed: false
class Dao::Team < ApplicationRecord
  belongs_to :product, class_name: 'Dao::Product', foreign_key: :dao_product_id, optional: true
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_team_id, dependent: :destroy

  def read
    Team::Team.from_repository(
      read_id,
      read_name,
      read_product_id,
      read_members,
    )
  end

  def write(team)
    self.attributes = {
      dao_product_id: team.product.to_s,
      name: team.name,
    }

    self.members.clear
    team.members.to_a.each do |member|
      member.roles.to_a.each do |role|
        self.members.build(dao_person_id: member.person_id, role: role.to_s)
      end
    end
  end

  private

  def read_id
    Team::Id.from_string(id)
  end

  def read_name
    name
  end

  def read_product_id
    return nil unless dao_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_members
    members
      .group_by(&:dao_person_id)
      .values
      .flat_map { |dao_members| build_member(dao_members) }
  end

  def build_member(dao_members)
    roles = dao_members.map { |m| Team::Role.from_string(m.role) }
    Team::Member.new(
      Person::Id.from_string(dao_members.first.dao_person_id),
      Team::RoleSet.new(roles),
    )
  end
end
