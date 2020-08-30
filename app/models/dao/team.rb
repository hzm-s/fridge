class Dao::Team < ApplicationRecord
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_team_id, dependent: :destroy
end
