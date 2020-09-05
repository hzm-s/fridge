class Dao::Team < ApplicationRecord
  belongs_to :product, class_name: 'Dao::Product', foreign_key: :dao_product_id, optional: true
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_team_id, dependent: :destroy
end
