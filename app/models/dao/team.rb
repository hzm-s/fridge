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
    team.members.to_a.each do |m|
      self.members.build(dao_person_id: m.person_id, role: m.role.to_s)
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
    Product::Id.from_string(dao_product_id)
  end

  def read_members
    members.map do |m|
      Team::Member.new(
        Person::Id.from_string(m.dao_person_id),
        Team::Role.from_string(m.role)
      )
    end
  end
end
