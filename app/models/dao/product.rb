# typed: strict
class Dao::Product < ApplicationRecord
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_product_id, dependent: :destroy
  has_many :backlog_items, class_name: 'Dao::ProductBacklogItem', foreign_key: :dao_product_id, dependent: :destroy
  has_one :order, class_name: 'Dao::ProductBacklogOrder', foreign_key: :dao_product_id, dependent: :destroy

  def product_id_as_do
    Product::Id.from_string(id)
  end

  def team_as_do
    Team::Team.new(team_members_as_do)
  end

  def team_members_as_do
    members.map do |m|
      Team::Member.new(User::Id.from_string(m.dao_user_id), Team::Role.deserialize(m.role))
    end
  end
end
