# typed: strict
class Dao::TeamMember < ApplicationRecord
  belongs_to :user, class_name: 'Dao::User', foreign_key: :dao_user_id
end
