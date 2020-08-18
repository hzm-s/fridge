# typed: false
class Dao::Person < ApplicationRecord
  has_one :user_account, class_name: 'App::UserAccount', foreign_key: :dao_person_id, dependent: :destroy
  has_many :team_members, class_name: 'Dao::TeamMember', foreign_key: :dao_person_id, dependent: :destroy
end
