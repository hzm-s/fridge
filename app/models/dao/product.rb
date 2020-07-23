# typed: strict
class Dao::Product < ApplicationRecord
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_product_id
end
