# typed: false
class Dao::Team < ApplicationRecord
  belongs_to :product, class_name: 'Dao::Product', foreign_key: :dao_product_id, optional: true
  has_many :members,
    class_name: 'Dao::TeamMember', foreign_key: :dao_team_id,
    dependent: :destroy, autosave: true

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

    self.members.each(&:mark_for_destruction)
    team.members.to_a.each do |member|
      self.members.build(
        dao_person_id: member.person_id,
        roles: member.roles.to_a.map(&:to_s)
      )
    end
  end

  private

  def read_id
    Team::Id.from_string(id)
  end

  def read_name
    Shared::Name.new(name)
  end

  def read_product_id
    return nil unless dao_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_members
    members.map(&:read)
  end
end
