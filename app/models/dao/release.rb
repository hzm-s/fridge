# typed: strict
class Dao::Release < ApplicationRecord
  has_many :items, class_name: 'Dao::ReleaseItem', foreign_key: :dao_release_id, dependent: :destroy
end
