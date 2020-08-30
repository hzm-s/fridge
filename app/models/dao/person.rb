# typed: true
class Dao::Person < ApplicationRecord
  has_one :user_account, class_name: 'App::UserAccount', foreign_key: :dao_person_id, dependent: :destroy
  has_many :team_members, class_name: 'Dao::TeamMember', foreign_key: :dao_person_id, dependent: :destroy

  def person_id_as_do
    Person::Id.from_string(id)
  end
end
